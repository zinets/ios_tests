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
            
        } break;
        case UIGestureRecognizerStateChanged: {
            CGFloat delta = pt.x - startPt.x;
            CGPoint center = startCenter;
            center.x += delta;
            
            CGFloat depth = 1;
            NSInteger numberOfCells = [self.collectionView numberOfItemsInSection:0];
            if (numberOfCells > 1) {
                CGFloat maxDepth = 1.0 / numberOfCells;
                BOOL nSign = delta < 0;
                depth = MIN(maxDepth, ABS(delta / (self.collectionView.bounds.size.width / 2)) / numberOfCells);
                if (nSign) {
                    depth = -depth;
                }
            }
            NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
            [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                StackCellAttributes *attr = [attributes[obj] copy];
                attr.depth -= depth; // copy чтобы не накапливалось изменение лавинообразно
                
                [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
            }];
            topCell.center = center;
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGFloat delta = pt.x - startPt.x;
            CGPoint center = startCenter;
            center.x += delta;
            CGPoint v = [sender velocityInView:sender.view];
            CGFloat timeToPredict = 0.15;
            center.x += timeToPredict * v.x;
            if (CGRectContainsPoint(self.collectionView.bounds, center)) {
                [UIView animateWithDuration:0.15 animations:^{
                    topCell.center = startCenter;
                    NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                    [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        StackCellAttributes *attr = attributes[obj];
                        [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                    }];
                }];
            } else {
                [UIView animateWithDuration:0.15 animations:^{
                    topCell.transform = CGAffineTransformMakeTranslation(center.x, 0);
                } completion:^(BOOL finished) {
                    topCell.alpha = 0;
//                    StackCellAttributes *attr = attributes[indexPath];
//                    attr.depth = 0;
//                    [topCell applyLayoutAttributes:attr];
                    
                    [self.delegate layout:self didRemoveItemAtIndexpath:indexPath];
                }];
            }
        } break;
        default:
            break;
    }
}

@end
