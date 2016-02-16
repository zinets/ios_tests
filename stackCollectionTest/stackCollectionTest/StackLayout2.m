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
    NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *attributes;
    
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
#warning а если 1 ячейка?
        attr.depth = (CGFloat) x / (numberOfItems - 1);
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
    UICollectionViewLayoutAttributes *attr = attributes[indexPath];
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
            
            topCell.center = center;
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGFloat delta = pt.x - startPt.x;
            CGPoint center = startCenter;
            center.x += delta;
            if (CGRectContainsPoint(self.collectionView.bounds, center)) {
                topCell.center = startCenter;
            } else {
                topCell.center = center;
                [self.delegate layout:self didRemoveItemAtIndexpath:indexPath];
            }
        } break;
        default:
            break;
    }
    [self invalidateLayout];
}

@end
