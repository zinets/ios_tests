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
#import "ViewShape.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableArray <NSNumber *> *ds;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ds = [NSMutableArray arrayWithObject:@0];

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
    return ds.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiamondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    if (indexPath.item == 4) {
        cell.backgroundColor = [[UIColor brownColor] colorWithAlphaComponent:0.5];
    }
    cell.number = [ds[indexPath.item] integerValue]; //indexPath.item;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", @(indexPath.item));
//    [collectionView.collectionViewLayout invalidateLayout];

    [[self.view viewWithTag:12] removeFromSuperview];

    if (indexPath.item == 4) {
        [(DiamondLayout *)collectionView.collectionViewLayout reset];
    } else
    if (indexPath.item == 3) {
        UIView *v = [[UIView alloc] initWithFrame:(CGRect){50, 50, 250, 250}];
        v.tag = 12;
        v.backgroundColor = [UIColor redColor];

        [self.view addSubview:v];

        [ViewShape applyShape:arc4random_uniform(ViewShapeCuttedCorner + 1) toView:v];
    } else
    if (indexPath.item % 2 == 0) {
        [ds addObject:@(ds.count)];

        [collectionView insertItemsAtIndexPaths:@[
                [NSIndexPath indexPathForItem:ds.count - 1 inSection:0]
        ]];
    } else {
        [ds removeLastObject];
        [collectionView deleteItemsAtIndexPaths:@[
                [NSIndexPath indexPathForItem:ds.count inSection:0]
        ]];
    }

}

@end