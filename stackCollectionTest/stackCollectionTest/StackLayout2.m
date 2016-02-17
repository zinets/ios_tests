//
//  PHLookingForInfo+dd.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/16/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackLayout.h"
#import "StackCellAttributes.h"
#import "UIView+Geometry.h"
#import "Utils.h"

typedef NS_ENUM(NSUInteger, CellScrollingDirection) {
    CellScrollingDirectionNone,
    /// возвращаем назад смахнутую карточку
    CellScrollingDirectionRestoring,
    /// убираем с экрана карточку
    CellScrollingDirectionRemoving,
};

@interface StackLayout2 ()
@property (nonatomic, assign) CellScrollingDirection scrollDirection;
@end

@implementation StackLayout2 {
    NSMutableDictionary <NSIndexPath *, StackCellAttributes *> *attributes;
    
    UIPanGestureRecognizer *panRecognizer;
    CGPoint startPt, startCenter;
    UIView *fakeCell;
}

-(CGSize)collectionViewContentSize {
    CGSize sz = self.collectionView.bounds.size;
    sz.width -= self.collectionView.contentInset.left + self.collectionView.contentInset.right;
    sz.height -= self.collectionView.contentInset.top + self.collectionView.contentInset.bottom;
    return sz;
}

- (NSInteger)numberOfItems {
    return MIN(4, [self.collectionView numberOfItemsInSection:0]);
}

-(void)prepareLayout {
    [super prepareLayout];
    if (!attributes) {
        attributes = [NSMutableDictionary dictionary];
    }
    
    if (!panRecognizer) {
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanRecognized:)];
        [self.collectionView addGestureRecognizer:panRecognizer];
    }
    
    CGFloat const height = 415.0;
    
    NSInteger numberOfItems = [self numberOfItems];
    for (int x = 0; x < numberOfItems; x++) {
        NSIndexPath *idx = [NSIndexPath indexPathForItem:x inSection:0];
        StackCellAttributes *attr = attributes[idx];
        if (!attr) {
            attr = [StackCellAttributes layoutAttributesForCellWithIndexPath:idx];
            [attributes setObject:attr forKey:idx];
        }
        attr.zIndex = 100 - x;
        if (self.scrollDirection == CellScrollingDirectionRestoring) {
            if (x == 0) {
                attr.frame = (CGRect){{15 + self.collectionView.bounds.size.width, 30}, {290, height}};
                attr.depth = 0;
            } else {
                attr.frame = (CGRect){{15, 30}, {290, height}};
                if (numberOfItems > 1) {
                    attr.depth = (CGFloat) (x - 1) / (numberOfItems - 1);
                }
            }
        } else {
            attr.frame = (CGRect){{15, 30}, {290, height}};
            if (numberOfItems > 1) {
                attr.depth = (CGFloat) x / (numberOfItems - 1);
            }
        }
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *> *res = [NSMutableArray array];
    for (int x = 0; x < [self numberOfItems]; x++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:0]];
        [res addObject:attr];
    }
    return res;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = attributes[indexPath];
    return attr;
}

#pragma mark - internal

#pragma mark - gestures

- (void)onPanRecognized:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            startPt = pt;
            self.scrollDirection = CellScrollingDirectionNone;
            
        } break;
        case UIGestureRecognizerStateChanged: {
            CGFloat delta = pt.x - startPt.x;
            // мы можем пальцем возюкать туды-сюды, но определив раз направление больше не меняем тип!
            if (self.scrollDirection == CellScrollingDirectionNone) {
                if (delta < 0 && [self.delegate hasRemovedItems:self]) {
                    self.scrollDirection = CellScrollingDirectionRestoring;
                } else {
                    self.scrollDirection = CellScrollingDirectionRemoving;

                } // думаю нет смысла проверять вариант, когда смещение == 0
                [self prepareLayout];
                NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    StackCellAttributes *attr = attributes[obj];
                    [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                }];

                UICollectionViewCell *topCell = [self.collectionView cellForItemAtIndexPath:indexPath];
                startCenter = topCell.center;
                
                fakeCell = [topCell snapshotViewAfterScreenUpdates:YES];
                borderControl(fakeCell);
                [self.collectionView addSubview:fakeCell];
                fakeCell.frame = topCell.frame;
                fakeCell.alpha = 1;
                topCell.alpha = 0;
                break;
            } else {
                
            }
            
            NSInteger numberOfCells = [self numberOfItems];;
            CGPoint center = startCenter;
            
            switch (self.scrollDirection) {
                case CellScrollingDirectionRemoving: {
                    center.x += delta;
                    CGFloat depth = 1;
                    if (numberOfCells > 1) {
                        CGFloat maxDepth = 1.0 / (numberOfCells - 1);
                        depth = MAX(0, MIN(maxDepth, delta / (self.collectionView.bounds.size.width / 2) / (numberOfCells - 1)));
                    }
                    NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                    [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj isEqual:indexPath]) {
                            StackCellAttributes *attr = [attributes[obj] copy];
                            attr.depth -= depth; // copy чтобы не накапливалось изменение лавинообразно
                            [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                        }
                    }];
                    fakeCell.center = center;
                } break;
                    
                default:
                    break;
            }
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            UICollectionViewCell *topCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            
            CGPoint v = [sender velocityInView:sender.view];
            CGFloat timeToPredict = 0.15;
            CGFloat delta = pt.x - startPt.x;
            __block CGPoint center = startCenter;
            center.x += delta + timeToPredict * v.x;
            
            switch (self.scrollDirection) {
                case CellScrollingDirectionRemoving: {
                    if (center.x > self.collectionView.bounds.size.width) { // смахивание справо срабатывает если не просто "за фрейм
                        center.x += self.collectionView.bounds.size.width;
                        [UIView animateWithDuration:0.25 animations:^{
                            fakeCell.center = center;
                            [self.delegate layout:self didRemoveItemAtIndexpath:indexPath];
                            [self invalidateLayout];
                            
                            NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                            [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                StackCellAttributes *attr = attributes[obj];
                                [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                            }];
                            fakeCell.alpha = 0;
                        } completion:^(BOOL finished) {
                            [fakeCell removeFromSuperview];
                        }];
                    } else {
                        center = startCenter;
                        [UIView animateWithDuration:0.25 animations:^{
                            fakeCell.center = center;
                            
                            NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                            [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (![obj isEqual:indexPath]) {
                                    StackCellAttributes *attr = attributes[obj];
                                    [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                                }
                            }];
                        } completion:^(BOOL finished) {
                            topCell.alpha = 1;
                            fakeCell.alpha = 0;
                            [fakeCell removeFromSuperview];
                        }];

                    }
                } break;
                    
                default:
                    break;
            }
        } break;
        default:
            break;
    }
}

//-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    StackCellAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    NSLog(@"%@", attr);
////    if (itemIndexPath.item == 0) {
//        attr.alpha = 0;
////        
////        CGPoint c = attr.center;
////        c.x += self.collectionView.bounds.size.width;
////        attr.center = c;
////    }
//    
//    return attr;
//}

@end
