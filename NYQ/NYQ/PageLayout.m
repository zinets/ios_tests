//
//  BookmarksPageLayout.m
//  Browser
//
//  Created by Zinets Victor on 5/28/15.
//  Copyright (c) 2015 Yarra. All rights reserved.
//

#import "PageLayout.h"

#import "BookmarkCellAttributes.h"
#import "UIView+Geometry.h"

typedef NS_ENUM(NSInteger, ScrollDirection) {
    ScrollDirectionUnknown,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionLeft,
    ScrollDirectionRight,
};

@interface PageLayout () <UIGestureRecognizerDelegate> {
    BOOL setupIsDone;
    // reordering
    UIView *_fakeCell; // по экрану возюкаем не ячейку, а ее картинку
    // длинный тап включает редактирование - "хытание" ячеек; и не отпуская ячейку можно возить по экрану
    UILongPressGestureRecognizer *longPressRecognizer;
    // тап-рекогнайзер нужен для выхода из режима редактирования
    UITapGestureRecognizer *tapRecognizer;
    // пан рекогнайзер ловит возюкания по экрану и вызывает пересортировку ячеек при возюкании фантомной
    UIPanGestureRecognizer *panRecognizer;
    
    NSIndexPath *lastIndexPath;
    CGPoint fingerPos, fakeCellCenter;
    ScrollDirection scrollDirection;
    CADisplayLink *timer;
}
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;
@property (strong, nonatomic) NSIndexPath *fromIndexPath;
@property (strong, nonatomic) NSIndexPath *toIndexPath;
@property (strong, nonatomic) NSIndexPath *hideIndexPath; // после длинного тапа ячейку спрячем и запомним ее индекс
@end


@implementation PageLayout

+(Class)layoutAttributesClass {
    return [BookmarkCellAttributes class];
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.itemSize = (CGSize){256, 256};
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.sectionInset = (UIEdgeInsets){0, 0, 0, 0};
        
        self.scrollingSpeed = 300.f;
        self.scrollingEdgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

-(void)setupGestures {
    longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
    longPressRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:longPressRecognizer];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:tapRecognizer];
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:panRecognizer];
    
    setupIsDone = YES;
}

#pragma mark - overrides

-(void)prepareLayout {
    [super prepareLayout];
    
    if (!setupIsDone) {
        [self setupGestures];
    }
    
//    if (CGRectIsLandscape(self.collectionView.bounds)) {
//        self.sectionInset = (UIEdgeInsets){8, 8, 8, 8};
//    } else {
//        self.sectionInset = (UIEdgeInsets){8, 8, 8, 8};
//    }
}

#pragma mark - setters

-(void)setEditingMode:(BOOL)editingMode {
    if (editingMode != _editingMode) {
        _editingMode = editingMode;
        [self invalidateLayout];
    }
}

#pragma mark - animation

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        switch (updateItem.updateAction) {
            case UICollectionUpdateActionInsert:
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionDelete:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            case UICollectionUpdateActionMove:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                [indexPaths addObject:updateItem.indexPathAfterUpdate];
                break;
            case UICollectionUpdateActionReload:
                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
                break;
            default:
                NSLog(@"unhandled case: %@", updateItem);
                break;
        }
    }
    self.indexPathsToAnimate = indexPaths;
}

// rotation support
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *res = [self modifiedLayoutAttributesForElements:[super layoutAttributesForElementsInRect:rect]];
    [res enumerateObjectsUsingBlock:^(BookmarkCellAttributes *attr, NSUInteger idx, BOOL *stop) {
        attr.editingModeActive = self.editingMode;
    }];
    return res;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookmarkCellAttributes *attr = (BookmarkCellAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    attr.editingModeActive = self.editingMode;
    return attr;
}

- (CGFloat)shiftValue {
        return -100;
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    if (!self.editingMode) {
        attr.center = (CGPoint){self.shiftValue, attr.center.y};
    }
    return attr;
}


-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = nil;
    
    if ([self.collectionView numberOfItemsInSection:0] == 0) { // у нас всего 1 секция пока что по крайней мере
        attr = [BookmarkCellAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
        attr.frame = (CGRect){CGPointZero, self.itemSize};
        attr.alpha = 0;
    } else {
        attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    }

    if (!self.editingMode) {
        attr.center = (CGPoint){-self.shiftValue, attr.center.y};
    }
    return attr;
}

#pragma mark - reodreding

- (NSArray *)modifiedLayoutAttributesForElements:(NSArray *)elements
{
    UICollectionView *collectionView = self.collectionView;
    NSIndexPath *fromIndexPath = self.fromIndexPath;
    NSIndexPath *toIndexPath = self.toIndexPath;
    NSIndexPath *hideIndexPath = self.hideIndexPath;
    NSIndexPath *indexPathToRemove;
    
    if (toIndexPath == nil) {
        if (hideIndexPath == nil) {
            return elements;
        }
        for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
            if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
                continue;
            }
            if ([layoutAttributes.indexPath isEqual:hideIndexPath]) {
                layoutAttributes.hidden = YES;
            }
        }
        return elements;
    }
    
    if (fromIndexPath.section != toIndexPath.section) {
        indexPathToRemove = [NSIndexPath indexPathForItem:[collectionView numberOfItemsInSection:fromIndexPath.section] - 1
                                                inSection:fromIndexPath.section];
    }
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in elements) {
        if(layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        if([layoutAttributes.indexPath isEqual:indexPathToRemove]) {
            // Remove item in source section and insert item in target section
            layoutAttributes.indexPath = [NSIndexPath indexPathForItem:[collectionView numberOfItemsInSection:toIndexPath.section]
                                                             inSection:toIndexPath.section];
            if (layoutAttributes.indexPath.item != 0) {
                layoutAttributes.center = [self layoutAttributesForItemAtIndexPath:layoutAttributes.indexPath].center;
            }
        }
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        if ([indexPath isEqual:hideIndexPath]) {
            layoutAttributes.hidden = YES;
        }
        if([indexPath isEqual:toIndexPath]) {
            // Item's new location
            layoutAttributes.indexPath = fromIndexPath;
        }
        else if(fromIndexPath.section != toIndexPath.section) {
            if(indexPath.section == fromIndexPath.section && indexPath.item >= fromIndexPath.item) {
                // Change indexes in source section
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }
            else if(indexPath.section == toIndexPath.section && indexPath.item >= toIndexPath.item) {
                // Change indexes in destination section
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
        }
        else if(indexPath.section == fromIndexPath.section) {
            if(indexPath.item <= fromIndexPath.item && indexPath.item > toIndexPath.item) {
                // Item moved back
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            }
            else if(indexPath.item >= fromIndexPath.item && indexPath.item < toIndexPath.item) {
                // Item moved forward
                layoutAttributes.indexPath = [NSIndexPath indexPathForItem:indexPath.item + 1 inSection:indexPath.section];
            }
        }
    }
    
    return elements;
}

#pragma mark - recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isEqual:longPressRecognizer]) {
        return [otherGestureRecognizer isEqual:panRecognizer];
    }
    
    if ([gestureRecognizer isEqual:panRecognizer]) {
        return [otherGestureRecognizer isEqual:longPressRecognizer];
    } 
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:panRecognizer]) {
        return self.fromIndexPath != nil;
    }
    if ([gestureRecognizer isEqual:tapRecognizer]) {
        return self.editingMode;
    }
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        fingerPos = [sender translationInView:self.collectionView];
        _fakeCell.center = CGPointAdd(fakeCellCenter, fingerPos);
        
        if ([self scrollDirection] == UICollectionViewScrollDirectionVertical) {
            if (_fakeCell.center.y < (CGRectGetMinY(self.collectionView.bounds) + self.scrollingEdgeInsets.top)) {
                [self setupScrollTimerInDirection:ScrollDirectionUp];
            } else {
                if (_fakeCell.center.y > (CGRectGetMaxY(self.collectionView.bounds) - self.scrollingEdgeInsets.bottom)) {
                    [self setupScrollTimerInDirection:ScrollDirectionDown];
                }
                else {
                    [self invalidatesScrollTimer];
                }
            }
        } else {
            if (_fakeCell.center.x < (CGRectGetMinX(self.collectionView.bounds) + self.scrollingEdgeInsets.left)) {
                [self setupScrollTimerInDirection:ScrollDirectionLeft];
            } else {
                if (_fakeCell.center.x > (CGRectGetMaxX(self.collectionView.bounds) - self.scrollingEdgeInsets.right)) {
                    [self setupScrollTimerInDirection:ScrollDirectionRight];
                } else {
                    [self invalidatesScrollTimer];
                }
            }
        }
        
        if (scrollDirection > ScrollDirectionUnknown) {
            return;
        }
        
        CGPoint point = [sender locationInView:self.collectionView];
        NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:point];
        [self warpToIndexPath:indexPath];
    }
}

- (void)handleLongTap:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged) {
        return;
    }
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            self.editingMode = YES;
            
            NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
            if (![self.delegate collectionView:self.collectionView canMoveItemAtIndexPath:index]) {
                return;
            }
            [_fakeCell removeFromSuperview];
            
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:index];
            _fakeCell = [cell snapshotViewAfterScreenUpdates:NO];
            _fakeCell.frame = cell.frame;
            
            [self.collectionView addSubview:_fakeCell];
            fakeCellCenter = _fakeCell.center;
            [UIView animateWithDuration:0.2 animations:^{
                _fakeCell.transform = CGAffineTransformMakeScale(1.1, 1.1);
            }];
            
            lastIndexPath = index;
            self.fromIndexPath = index;
            self.hideIndexPath = index;
            self.toIndexPath = index;
            [self invalidateLayout];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (self.fromIndexPath == nil) {
                return;
            }
            
            NSIndexPath *fromIndexPath = self.fromIndexPath;
            NSIndexPath *toIndexPath = self.toIndexPath;
            
            [self.collectionView performBatchUpdates:^{
                [self.delegate collectionView:self.collectionView didMoveItemAtPath:fromIndexPath toPath:toIndexPath];
               
                [self.collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                self.fromIndexPath = nil;
                self.toIndexPath = nil;
            } completion:^(BOOL finished) {
            }];
            
            UICollectionViewLayoutAttributes *layoutAttributes = [self.collectionView layoutAttributesForItemAtIndexPath:self.hideIndexPath];
            [UIView animateWithDuration:0.2  animations:^{
                _fakeCell.center = layoutAttributes.center;
                _fakeCell.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [_fakeCell removeFromSuperview];
                _fakeCell = nil;
                self.hideIndexPath = nil;
                [self invalidateLayout];
            }];
            
            [self invalidatesScrollTimer];
            lastIndexPath = nil;
            
            if (self.collectionView.contentOffset.y <= 0) {
                CGPoint pt = self.collectionView.contentOffset;
                pt.y = -self.collectionView.contentInset.top;
                [self.collectionView setContentOffset:pt animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

-(void)handleTap:(UITapGestureRecognizer *)sender {
    self.editingMode = NO;
    if ([self.delegate respondsToSelector:@selector(wasTapAt:)]) {
        CGPoint pt = [sender locationInView:self.collectionView];
        NSIndexPath * path = [self.collectionView indexPathForItemAtPoint:pt];
        if (path)
            [self.delegate wasTapAt:path];
    }
}

#pragma mark - timer

- (void)invalidatesScrollTimer {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    scrollDirection = ScrollDirectionUnknown;
}

- (void)setupScrollTimerInDirection:(ScrollDirection)direction {
    scrollDirection = direction;
    if (timer == nil) {
        timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleScroll:)];
        [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)handleScroll:(NSTimer *)timer {
    if (scrollDirection == ScrollDirectionUnknown) {
        return;
    }
    
    CGSize frameSize = self.collectionView.size;
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGFloat distance = self.scrollingSpeed / 60.f;
    CGPoint translation = CGPointZero;
    
    switch (scrollDirection) {
        case ScrollDirectionUp: {
            distance = -distance;
            if ((contentOffset.y + distance) <= 0) {
                distance = -contentOffset.y;
            }
            translation = (CGPoint){0, distance};
        }
            break;
        case ScrollDirectionDown: {
            CGFloat maxY = MAX(contentSize.height, frameSize.height) - frameSize.height;
            if ((contentOffset.y + distance) >= maxY) {
                distance = maxY - contentOffset.y;
            }
            translation = (CGPoint){0, distance};
        }
            break;
        case ScrollDirectionLeft: {
            distance = -distance;
            if ((contentOffset.x + distance) <= 0) {
                distance = -contentOffset.x;
            }
            translation = (CGPoint){distance, 0};
        }
            break;
        case ScrollDirectionRight: {
            CGFloat maxX = MAX(contentSize.width, frameSize.width) - frameSize.width;
            if ((contentOffset.x + distance) >= maxX) {
                distance = maxX - contentOffset.x;
            }
            translation = (CGPoint){distance, 0};
        }
            break;
        default:
            break;
    }
    
    fakeCellCenter = CGPointAdd(fakeCellCenter, translation);
    _fakeCell.center = CGPointAdd(fakeCellCenter, fingerPos);
        
    self.collectionView.contentOffset = CGPointAdd(contentOffset, translation);
    NSIndexPath *indexPath = [self indexPathForItemClosestToPoint:_fakeCell.center];
    [self warpToIndexPath:indexPath];
}

#pragma mark - helpers

- (void)warpToIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == nil || [lastIndexPath isEqual:indexPath]) {
        return;
    }
    if (![self.delegate collectionView:self.collectionView canMoveItemAtIndexPath:self.fromIndexPath toIndexPath:indexPath]) {
        return;
    }
    lastIndexPath = indexPath;
    [self.collectionView performBatchUpdates:^{
        self.hideIndexPath = indexPath;
        self.toIndexPath = indexPath;
    } completion:nil];
}

- (NSIndexPath *)indexPathForItemClosestToPoint:(CGPoint)point {
    NSArray *layoutAttrsInRect;
    NSInteger closestDist = NSIntegerMax;
    NSIndexPath *indexPath;
    NSIndexPath *toIndexPath = self.toIndexPath;
    
    self.toIndexPath = nil;
    layoutAttrsInRect = [self layoutAttributesForElementsInRect:self.collectionView.bounds];
    self.toIndexPath = toIndexPath;
    
    for (UICollectionViewLayoutAttributes *layoutAttr in layoutAttrsInRect) {
        CGFloat xd = layoutAttr.center.x - point.x;
        CGFloat yd = layoutAttr.center.y - point.y;
        NSInteger dist = sqrtf(xd * xd + yd * yd);
        if (dist < closestDist) {
            closestDist = dist;
            indexPath = layoutAttr.indexPath;
        }
    }
    
    NSInteger sections = [self.collectionView numberOfSections];
    for (NSInteger i = 0; i < sections; ++i) {
        if (i == self.fromIndexPath.section) {
            continue;
        }
        
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:items inSection:i];
        UICollectionViewLayoutAttributes *layoutAttr;
        CGFloat xd, yd;
        
        if (items > 0) {
            layoutAttr = [self layoutAttributesForItemAtIndexPath:nextIndexPath];
            xd = layoutAttr.center.x - point.x;
            yd = layoutAttr.center.y - point.y;
        } else {
            layoutAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:nextIndexPath];
            xd = layoutAttr.frame.origin.x - point.x;
            yd = layoutAttr.frame.origin.y - point.y;
        }
        
        NSInteger dist = sqrtf(xd * xd + yd * yd);
        if (dist < closestDist) {
            closestDist = dist;
            indexPath = layoutAttr.indexPath;
        }
    }
    
    return indexPath;
}

@end
