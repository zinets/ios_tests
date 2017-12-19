//
// Created by Zinets Viktor on 12/19/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "DiamondLayout.h"


@implementation DiamondLayout {
    NSMutableArray *attributes;
    CGSize contentSize;
}

- (void)prepareLayout {
    if (!attributes) {
        attributes = [NSMutableArray arrayWithCapacity:9];
    } else {
        [attributes removeAllObjects];
    }

    contentSize = (CGSize){self.collectionView.bounds.size.width, 0};

    CGFloat cellWidth = 110;
    CGFloat bigCellWidth = 254;
    CGFloat spacing = 34;
    CGFloat const inset = 24;
    CGFloat overlap = 72;

    // если по дизу может быть макс. 12 элементов мин. размера, то есть всего 4 варианта раскладки с большими элементами
    NSDictionary *m = @{
            @0 : @[@0, @1, @5, @6, @7, @8, @9, @10, @11],
            @3 : @[@0, @1, @2, @3, @6, @8, @9, @10, @11],
            @4 : @[@0, @1, @2, @3, @4, @5, @9, @10, @11],
            @7 : @[@0, @1, @2, @3, @4, @5, @6, @7, @10],
    };

    NSNumber *bigCell = m.allKeys[arc4random_uniform(m.count)];
    NSArray <NSNumber *> *indexes = m[bigCell];
    NSInteger numOfCells = [self.collectionView numberOfItemsInSection:0];

    [indexes enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        int x = [obj integerValue];
        CGFloat xPos = inset + (1 - (x % 4) / 2) * overlap + (x % 2) * (cellWidth + spacing);
        CGFloat yPos = inset + overlap * (x / 2);

        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];

        if ([obj isEqualToNumber:bigCell]) {
            attr.center = (CGPoint) {xPos + cellWidth / 2, yPos + bigCellWidth / 2};
            attr.size = (CGSize) {bigCellWidth, bigCellWidth};
        } else {
            attr.center = (CGPoint) {xPos + cellWidth / 2, yPos + cellWidth / 2};
            attr.size = (CGSize) {cellWidth, cellWidth};
        }
        [attributes addObject:attr];

        contentSize.height = MAX(contentSize.height, attr.frame.origin.y + attr.frame.size.height);

        *stop = idx == numOfCells - 1;
    }];
    contentSize.height += inset;
}

- (CGSize)collectionViewContentSize {
    return contentSize;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return attributes[indexPath.item];
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arr = [NSMutableArray arrayWithArray:attributes];
    [arr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attr, NSUInteger idx, BOOL *stop) {
        if (!CGRectIntersectsRect(rect, attr.frame)) {
            [arr removeObject:attr];
        }
    }];
    return arr;
}

@end