//
//  PackagesContainerLayout.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PackagesContainerLayout.h"

@implementation PackagesContainerLayout {
    NSMutableArray <UICollectionViewLayoutAttributes *> *cache;
}

CGFloat dragOffset = 50;
CGFloat leftOffset = 40;

- (instancetype)init {
    if (self = [super init]) {
        _itemSize = (CGSize){180, 180};
        _selectedItemSize = (CGSize){244, 244};
        
        cache = [NSMutableArray new];
    }
    return self;
}

- (NSInteger)selectedItemIndex {
    return MAX(0, self.collectionView.contentOffset.x / (leftOffset + _itemSize.width));
}

- (CGFloat)nextItemPercentageOffset {
    return self.collectionView.contentOffset.x / dragOffset - self.selectedItemIndex;
}

#pragma mark -

- (NSInteger)numberOfItems {
    return [self.collectionView numberOfItemsInSection:0];
}

- (CGFloat)width {
    return self.collectionView.bounds.size.width;
}

- (CGFloat)height {
    return self.collectionView.bounds.size.height;
}

#pragma mark -

-(CGSize)collectionViewContentSize {
    CGFloat contentWidth = leftOffset;
    contentWidth += self.numberOfItems * dragOffset + (self.width - dragOffset);
    contentWidth += (self.numberOfItems - 1) * 16;
    return (CGSize){contentWidth, self.height};
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    __block NSMutableArray *arr = [NSMutableArray new];
    [cache enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(obj.frame, rect)) {
            [arr addObject:obj];
        }
    }];
    return arr;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    NSInteger itemIndex = round(proposedContentOffset.x / dragOffset);
    CGFloat xOffset = itemIndex * dragOffset;
    return (CGPoint){xOffset, 0};
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(void)prepareLayout {
    [cache removeAllObjects];
    
    CGRect frame = CGRectZero;
    CGFloat x = 0;
    
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.zIndex = item;
        
        CGFloat width = self.itemSize.width;
        if (indexPath.item == [self selectedItemIndex]) {
            CGFloat xOffset = self.itemSize.width * [self nextItemPercentageOffset];
            x = self.collectionView.contentOffset.x - xOffset;
            width = self.selectedItemSize.width;
        } else if (indexPath.item == [self selectedItemIndex] + 1 && indexPath.item != [self.collectionView numberOfItemsInSection:0]) {
            CGFloat maxX = x + self.itemSize.width;
            width = self.itemSize.width + MAX((self.selectedItemSize.width - self.itemSize.width) * [self nextItemPercentageOffset], 0);
            x = maxX - width;
        }
        frame = (CGRect){x, self.height - width, width, width};
        attributes.frame = frame;
        [cache addObject:attributes];
        x = CGRectGetMaxX(frame) + 16;
    }
}

@end
