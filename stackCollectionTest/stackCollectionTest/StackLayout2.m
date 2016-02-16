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
}

-(CGSize)collectionViewContentSize {
    CGSize sz = self.collectionView.bounds.size;
    sz.width -= self.collectionView.contentInset.left + self.collectionView.contentInset.right;
    sz.height -= self.collectionView.contentInset.top + self.collectionView.contentInset.bottom;
    return sz;
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
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    for (int x = 0; x < numberOfItems; x++) {
        NSIndexPath *idx = [NSIndexPath indexPathForItem:x inSection:0];
        StackCellAttributes *attr = attributes[idx];
        if (!attr) {
            attr = [StackCellAttributes layoutAttributesForCellWithIndexPath:idx];
            [attributes setObject:attr forKey:idx];
        }
        attr.frame = (CGRect){{15, 30}, {290, height}};
        attr.zIndex = 100 - x;
        if (numberOfItems > 1) {
            attr.depth = (CGFloat) x / (numberOfItems - 1);
        }
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *> *res = [NSMutableArray array];
    for (int x = 0; x < [self.collectionView numberOfItemsInSection:0]; x++) {
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewCell *topCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CGPoint pt = [sender locationInView:self.collectionView];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            startPt = pt;
            startCenter = topCell.center;
            self.scrollDirection = CellScrollingDirectionNone;
        } break;
        case UIGestureRecognizerStateChanged: {
            CGFloat delta = pt.x - startPt.x;
            // мы можем пальцем возюкать туды-сюды, но определив раз направление больше не меняем тип!
            if (self.scrollDirection == CellScrollingDirectionNone) {
                if (delta < 0) {
                    self.scrollDirection = CellScrollingDirectionRestoring;
                } else {
                    self.scrollDirection = CellScrollingDirectionRemoving;
                } // думаю нет смысла проверять вариант, когда смещение == 0
            }
            
            NSInteger numberOfCells = [self.collectionView numberOfItemsInSection:0];
            CGPoint center = startCenter;
            
            switch (self.scrollDirection) {
                case CellScrollingDirectionRemoving: {
                    center.x += delta;
                    CGFloat depth = 1;
                    if (numberOfCells > 1) {
                        CGFloat maxDepth = 1.0 / numberOfCells;
                        depth = MAX(0, MIN(maxDepth, delta / (self.collectionView.bounds.size.width / 2) / numberOfCells));
                    }
                    NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                    [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        StackCellAttributes *attr = [attributes[obj] copy];
                        attr.depth -= depth; // copy чтобы не накапливалось изменение лавинообразно
                        [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                    }];
                    topCell.center = center;
                } break;
                    
                default:
                    break;
            }
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGPoint v = [sender velocityInView:sender.view];
            CGFloat timeToPredict = 0.15;
            CGFloat delta = pt.x - startPt.x;
            CGPoint center = startCenter;
            center.x += delta + timeToPredict * v.x;
            
            switch (self.scrollDirection) {
                case CellScrollingDirectionRemoving: {
                    if (center.x > self.collectionView.bounds.size.width) { // смахивание справо срабатывает если не просто "за фрейм коллекции, а только "справа от коллекции"
                        [UIView animateWithDuration:0.15 animations:^{
                            topCell.transform = CGAffineTransformMakeTranslation(center.x, 0);
                        } completion:^(BOOL finished) {
                            topCell.alpha = 0;
                            //                    StackCellAttributes *attr = attributes[indexPath];
                            //                    attr.depth = 0;
                            //                    [topCell applyLayoutAttributes:attr];
                            
                            [self.delegate layout:self didRemoveItemAtIndexpath:indexPath];
                        }];
                    } else {
                        [UIView animateWithDuration:0.15 animations:^{
                            topCell.center = startCenter;
                            NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                            [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                StackCellAttributes *attr = attributes[obj];
                                [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                            }];
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

@end
