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
        if (self->toRemove.count) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:self->toRemove.count];
            [self->toRemove enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                // todo секции! хз; может просто как свойство класса?
                [array addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
            }];
            [self.collectionView deleteItemsAtIndexPaths:array];
        }
        if (self->toInsert.count) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:self->toInsert.count];
            [self->toInsert enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [array addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
            }];
            [self.collectionView insertItemsAtIndexPaths:array];
        }
        if (self->toUpdate.count) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:self->toUpdate.count];
            [self->toUpdate enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
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
