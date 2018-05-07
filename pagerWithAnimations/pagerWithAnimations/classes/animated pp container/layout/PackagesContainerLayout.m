//
//  PackagesContainerLayout.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PackagesContainerLayout.h"
#import "PackageCellLayoutAttributes.h"

@implementation PackagesContainerLayout {
    NSMutableArray <UICollectionViewLayoutAttributes *> *cache;
    BOOL shouldUpdateInsets;
}

- (instancetype)init {
    if (self = [super init]) {
        _itemSize = (CGSize){180, 180};
        _selectedItemSize = (CGSize){244, 244};
        _minimumInterItemSpacing = 16;
        
        cache = [NSMutableArray new];
    }
    return self;
}

#pragma mark magic -

// берем значение из диза для 4.7 (375 пк), получаем эквивалент для текущего экрана

- (CGFloat)dpFrom:(CGFloat)value {
    static CGFloat magicValue = 0;
    static BOOL needConversation = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        magicValue = [UIScreen mainScreen].bounds.size.width / 375.;
        needConversation = magicValue != 1;
    });
    
    return needConversation ? round(value * magicValue) : value;
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

#pragma mark helpers -

- (NSInteger)numberOfItems {
    return [self.collectionView numberOfItemsInSection:0];
}

- (CGFloat)width {
    return self.collectionView.bounds.size.width;
}

- (CGFloat)height {
    return self.collectionView.bounds.size.height;
}

#pragma mark setters/getters -

-(void)setItemSize:(CGSize)itemSize {
    _itemSize = (CGSize){[self dpFrom:itemSize.width], [self dpFrom:itemSize.height]};
}

-(void)setSelectedItemSize:(CGSize)selectedItemSize {
    _selectedItemSize = (CGSize){[self dpFrom:selectedItemSize.width], [self dpFrom:selectedItemSize.height]};
}

-(void)setLeftPadding:(CGFloat)leftPadding {
    _leftPadding = [self dpFrom:leftPadding];
    shouldUpdateInsets = YES;
}

-(CGFloat)bottomPadding {
    CGFloat vertPadding = 16; // неснижаемый остаток, если высота коллекции не позволяет - уменьшаем высоту ячейки на 16 сверху-снизу (а вообще ячейка "центруется" по вертикали, имея в виду бОльший размер ячейки; мЕньшие выравниваются по низу с большой)
    if (self.height - 2 * vertPadding > _selectedItemSize.height) {
        vertPadding = (self.height - _selectedItemSize.height) / 2;
    }
    
    return vertPadding;
}

#pragma mark -

-(CGSize)collectionViewContentSize {
    CGFloat contentWidth = (_itemSize.width + _minimumInterItemSpacing) * ([self numberOfItems] - 1) + _selectedItemSize.width;
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

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//    // простая дотяжка
//    NSInteger itemIndex = round((proposedContentOffset.x + self.collectionView.contentInset.left) / (_itemSize.width + _minimumInterItemSpacing));
//    
//    CGFloat xOffset = itemIndex * (_itemSize.width + _minimumInterItemSpacing) - self.collectionView.contentInset.left;
//    return (CGPoint){xOffset, 0};
//    
//    
//    
//}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(void)prepareLayout {
    if (shouldUpdateInsets) { //
        shouldUpdateInsets = NO;
        
        CGFloat rightPadding = self.width - _leftPadding - _selectedItemSize.width;
        UIEdgeInsets origInsets = self.collectionView.contentInset;
        origInsets.left = _leftPadding;
        origInsets.right = rightPadding;
        self.collectionView.contentInset = origInsets;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    [cache removeAllObjects];
    
    CGRect frame = CGRectZero;
    CGFloat x = 0;
    for (int item = 0; item < [self.collectionView numberOfItemsInSection:0]; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        PackageCellLayoutAttributes *attributes = [PackageCellLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        CGFloat width = self.itemSize.width;
        CGFloat maxSizeInc = self.selectedItemSize.width - width;
        
        NSInteger selectedIndex = [self selectedItemIndex];
        if (indexPath.item == selectedIndex) {
            x = selectedIndex * (_itemSize.width + _minimumInterItemSpacing);
            width = self.selectedItemSize.width - MAX(maxSizeInc * [self nextItemPercentageOffset], 0);
            
            attributes.growingPercent = 1 - (_selectedItemSize.width - width) / maxSizeInc;
        } else if (indexPath.item == selectedIndex + 1) {
            width = self.itemSize.width + MAX(maxSizeInc * [self nextItemPercentageOffset], 0);
            
            attributes.growingPercent = 1 - (_selectedItemSize.width - width) / maxSizeInc;
        } else {
            attributes.growingPercent = 0;
        }

        CGFloat height = width;
        if (height > self.height - 2 * self.bottomPadding) {
            height = self.height - 2 * self.bottomPadding;
        }
        
        frame = (CGRect){x, self.height - height - self.bottomPadding, width, height};
        attributes.frame = frame;
        [cache addObject:attributes];
        
        x = CGRectGetMaxX(frame) + self.minimumInterItemSpacing;
    }
}

@end
