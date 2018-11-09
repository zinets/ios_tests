//
//  BlindHorizBarabanLayout.m
//  autoCollectionCell
//
//  Created by Victor Zinets on 11/8/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "BlindHorizBarabanLayout.h"

@implementation BlindHorizBarabanLayout

-(instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
    }
    return self;
}

-(void)prepareLayout {
    [super prepareLayout];
    
    if (self.collectionView) {
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        UIEdgeInsets ei = self.collectionView.contentInset;
        NSInteger numberOfCells = [self.collectionView numberOfItemsInSection:0];
        if (numberOfCells > 0) {
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
            CGFloat inset = (self.collectionView.bounds.size.width - attr.size.width) / 2;
            ei.left = inset;
        }
        if (numberOfCells > 1) {
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:numberOfCells - 1 inSection:0]];
            CGFloat inset = (self.collectionView.bounds.size.width - attr.size.width) / 2;
            ei.right = inset;
        }
        
        self.collectionView.contentInset = ei;
    }
}

#pragma mark - дотяжка

- (UICollectionViewLayoutAttributes *)closestTo:(CGFloat)x {
    UICollectionViewLayoutAttributes *attr = nil;
    CGFloat const w = self.collectionView.bounds.size.width;
    CGFloat const h = self.collectionView.bounds.size.height;
    CGRect rect = (CGRect){x - w, 0, w, h};
    NSArray <UICollectionViewLayoutAttributes *> *attrs = [self layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *obj in attrs) {    
        if (ABS(obj.center.x - x) < ABS(attr.center.x - x)) {
            attr = obj;
        }
    }
    
    return attr;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat halfWidth = self.collectionView.bounds.size.width / 2;
    CGFloat newCenter = proposedContentOffset.x + halfWidth;
    UICollectionViewLayoutAttributes *attr = [self closestTo:newCenter];
    if (attr) {
        return (CGPoint){attr.center.x - halfWidth, proposedContentOffset.y};
    } else {
        return [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
    }
}

@end
