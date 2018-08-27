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
        return cell;
    }
    return nil;
}

#pragma mark setters -

// бесконечная прокрутка реализована как перестановка элементов первого -> последний и наоборот + отключение "автоанимации"
// но инициатором должен быть кто-то, кто будет следить за прокруткой или просто по таймеру говорить "дальше!"

- (void)shiftDataPrev {
    NSMutableArray *data = [self.items mutableCopy];
    id firstObject = [data firstObject];
    [data removeObject:firstObject];
    [data addObject:firstObject];

    [UIView setAnimationsEnabled:NO];
    self.items = data;
    [UIView setAnimationsEnabled:YES];
}

- (void)shiftDataNext {
    NSMutableArray *data = [self.items mutableCopy];
    id lastObject = [data lastObject];
    [data removeObject:lastObject];
    [data insertObject:lastObject atIndex:0];

    [UIView setAnimationsEnabled:NO];
    self.items = data;
    [UIView setAnimationsEnabled:YES];
}

#pragma mark поддержка "фулскринности", все что нужно для анимирования изменения размеров коллекции -

-(UIImage *)image {
    PhotoFromInternetCell *cell = (id)[[self.collectionView visibleCells] firstObject];
    return cell.image;
}

@end
