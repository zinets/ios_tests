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
    _columnsCount = NSAutocalculatedCount;
    _maxCountOfColumns = NSIntegerMax;
    _minimumInteritemSpacing = 8;
}

-(void)setColumnsCount:(NSInteger)columnsCount {
    if (columnsCount != _columnsCount && columnsCount > 0) {
        _columnsCount = columnsCount;
        [self invalidateLayout];
    }
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

-(NSInteger)capacityOfLayoutMaxCount:(NSInteger)maxCount {
    framesCalculator.cols = _columnsCount == NSAutocalculatedCount ? [framesCalculator proposedNumberOfColumnsFor:maxCount maxCountOfColumns:self.maxCountOfColumns] : _columnsCount;
    return framesCalculator.numberOfItems;
}

- (void)prepareLayout {
    [pool removeAllObjects];

    framesCalculator.bounds = self.collectionView.bounds;

    NSInteger numberOfElementsInCollection = [self.collectionView numberOfItemsInSection:0];
    framesCalculator.cols = _columnsCount == NSAutocalculatedCount ? [framesCalculator proposedNumberOfColumnsFor:numberOfElementsInCollection maxCountOfColumns:self.maxCountOfColumns] : _columnsCount;
    CGSize elementSize = framesCalculator.elementSize;
    NSInteger numberOfElements = MIN(framesCalculator.numberOfItems, numberOfElementsInCollection);
    for (int x = 0; x < numberOfElements; x++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:x inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        attributes.frame = CGRectInset((CGRect){{}, elementSize}, self.minimumInteritemSpacing, self.minimumInteritemSpacing);
        attributes.center = [framesCalculator.centers[x] CGPointValue];

        [pool addObject:attributes];
    }
}

@end
