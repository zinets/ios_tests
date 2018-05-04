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

- (instancetype)init {
    if (self = [super init]) {
        _itemSize = (CGSize){180, 180};
        _selectedItemSize = (CGSize){244, 244};
        
        cache = [NSMutableArray new];
    }
    return self;
}

// это позиция "активной" ячейки..
- (CGFloat)currentPos {
    CGFloat res = (self.collectionView.contentOffset.x + self.collectionView.contentInset.left) / (self.minimumInterItemSpacing + _itemSize.width);
    return res;
}

// .. это ее индекс
- (NSInteger)selectedItemIndex {
    NSInteger res = MAX(0, self.currentPos);
    return res;
}

// ф-ция возвращает значение от 0 до 1 для "активной" ячейки по мере ее приближения справа/слева к максимуму
- (CGFloat)nextItemPercentageOffset {
    // 0..1
    CGFloat res = self.currentPos - self.selectedItemIndex;
    
    return res;
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
    CGFloat contentWidth = (_itemSize.width + _minimumInterItemSpacing) * [self numberOfItems] - _minimumInterItemSpacing;
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

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    NSInteger itemIndex = round(proposedContentOffset.x / (_itemSize.width + _minimumInterItemSpacing));
    CGFloat xOffset = itemIndex * (_itemSize.width + _minimumInterItemSpacing) - self.collectionView.contentInset.left;
    return (CGPoint){xOffset, 0};
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(void)prepareLayout {
    if ([self selectedItemIndex] == 1 || [self nextItemPercentageOffset] == 0.5) {
        NSLog(@"");
    }
    [cache removeAllObjects];
    
    CGRect frame = CGRectZero;
    CGFloat x = 0;
    
//    NSLog(@"%f", [self nextItemPercentageOffset]);
    
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.zIndex = item;
        
        CGFloat width = self.itemSize.width;
        CGFloat maxSizeInc = self.selectedItemSize.width - width;
        
        NSInteger selectedIndex = [self selectedItemIndex];
        if (indexPath.item == selectedIndex) {
            x = selectedIndex * (_itemSize.width + _minimumInterItemSpacing);
            width = self.selectedItemSize.width - MAX(maxSizeInc * [self nextItemPercentageOffset], 0);
        } else if (indexPath.item == selectedIndex + 1) {
            width = self.itemSize.width + MAX(maxSizeInc * [self nextItemPercentageOffset], 0);
        }
        
        frame = (CGRect){x, self.height - width, width, width};
        attributes.frame = frame;
        [cache addObject:attributes];
        
        x = CGRectGetMaxX(frame) + self.minimumInterItemSpacing;
    }
}

@end
