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

//-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
//    return YES;
//}

- (UICollectionViewLayoutAttributes *)closestTo:(CGFloat)x {
    UICollectionViewLayoutAttributes *attr;
    attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
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
