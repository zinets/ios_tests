//
//  MiniMediaPicker.m
//  testConversations
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "MiniMediaPicker.h"
#import "MediaPickerCell.h"

@interface MiniMediaPicker() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation MiniMediaPicker

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *l = [UICollectionViewFlowLayout new];
        l.minimumLineSpacing = l.minimumInteritemSpacing = 2;
        CGFloat w = floor((self.bounds.size.width - l.minimumInteritemSpacing) / 2);
        CGFloat h = w * 1.25; // я так вижу.. из диза
        l.itemSize = (CGSize){w, h};
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:l];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MediaPickerCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    return cell;
}


@end
