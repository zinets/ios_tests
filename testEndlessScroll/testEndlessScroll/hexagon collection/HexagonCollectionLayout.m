//
// Created by Victor Zinets on 5/11/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "HexagonCollectionLayout.h"
#import "HexagonCalculator.h"

@interface HexagonCollectionLayout() {
    NSMutableArray <UICollectionViewLayoutAttributes *> *pool;
    HexagonCalculator *framesCalculator;
}

@end

@implementation HexagonCollectionLayout {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    pool = [NSMutableArray new];
    framesCalculator = [HexagonCalculator new];
}

#pragma mark required -

-(CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray array];
    [pool enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsRect(self.collectionView.bounds, obj.frame)) {
            [array addObject:obj];
        }
    }];
    return array;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return pool[indexPath.item];
}

- (void)prepareLayout {
    [pool removeAllObjects];
    framesCalculator.bounds = self.collectionView.bounds;
    // todo: можно как-то определять тут кол-во столбцов в зависимости от кол-ва элементов (порисовать и посмотреть?)
    framesCalculator.cols = 4;

    CGSize elementSize = framesCalculator.elementSize;
    NSInteger numberOfElements = MIN(framesCalculator.numberOfItems, [self.collectionView numberOfItemsInSection:0]);
    for (int x = 0; x < numberOfElements; x++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:x inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = (CGRect){{}, elementSize};
        attributes.center = [framesCalculator.centers[x] CGPointValue];

        [pool addObject:attributes];
    }
}

@end
