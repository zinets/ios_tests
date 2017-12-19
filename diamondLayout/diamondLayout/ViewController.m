//
//  ViewController.m
//  DiamondLayout
//
//  Created by Zinets Viktor on 12/19/17.
//  Copyright © 2017 TogetherN. All rights reserved.
//

#import "ViewController.h"
#import "DiamondLayout.h"
#import "DiamondCell.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        DiamondLayout *layout = [DiamondLayout new];

        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){0, 70, self.view.bounds.size.width, 520}
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor yellowColor];
        [_collectionView registerClass:[DiamondCell class] forCellWithReuseIdentifier:@"cell"];

        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiamondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    if (indexPath.item == 4) {
        cell.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.5];
    }
    cell.number = indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", @(indexPath.item));
//    [collectionView.collectionViewLayout invalidateLayout];
}

@end