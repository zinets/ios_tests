//
//  HexagonalCollectionDatasource.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "HexagonalCollectionDatasource.h"
#import "HexagonCell.h"


@implementation HexagonalCollectionDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return internalItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HexagonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HexagonCell" forIndexPath:indexPath];
    cell.data = internalItems[indexPath.item];
//    cell.backgroundColor = [[UIColor colorWithHex:arc4random() & 0xffffff] colorWithAlphaComponent:1];
//    //    cell.label.text = [NSString stringWithFormat:@"%d", indexPath.item];
    
    return cell;
}

@end
