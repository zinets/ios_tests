//
// Created by Victor Zinets on 2/6/18.
// Copyright (c) 2018 Together Networks. All rights reserved.
//

#import "CollectionSectionDatasource.h"

@implementation CollectionSectionDatasource {

}

- (void)setCollectionView:(UICollectionView *)collectionView {
    _collectionView = collectionView;
    _collectionView.dataSource = self;
}

- (void)setItems:(NSArray *)items {
    [super setItems:items];

    [self.collectionView performBatchUpdates:^{
        if (toRemove.count) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:toRemove.count];
            [toRemove enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                // todo секции! хз; может просто как свойство класса?
                [array addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
            }];
            [self.collectionView deleteItemsAtIndexPaths:array];
        }
        if (toInsert.count) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:toInsert.count];
            [toInsert enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [array addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
            }];
            [self.collectionView insertItemsAtIndexPaths:array];
        }
        if (toUpdate.count) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:toUpdate.count];
            [toUpdate enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [array addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
            }];
            [self.collectionView reloadItemsAtIndexPaths:array];
        }
    } completion:^(BOOL finished) {

    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end