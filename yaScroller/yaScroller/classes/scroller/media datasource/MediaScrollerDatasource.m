//
//  MediaScrollerDatasource.m
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "MediaScrollerDatasource.h"
#import "PhotoFromInternetCell.h"

@implementation MediaScrollerDatasource

#pragma mark overrides -

-(void)setCollectionView:(UICollectionView *)collectionView {
    [super setCollectionView:collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PhotoFromInternetCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoFromInternetCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.items[indexPath.item] isKindOfClass:[PhotoFromInternet class]]) {
        PhotoFromInternetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoFromInternetCell" forIndexPath:indexPath];
        cell.data = self.items[indexPath.item];
        cell.fs = self.fs;
        return cell;
    }
    return nil;
}

#pragma mark setters -

-(void)setFs:(BOOL)fs {
    _fs = fs;
    [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ((PhotoFromInternetCell *)obj).fs = _fs;
    }];
}

@end
