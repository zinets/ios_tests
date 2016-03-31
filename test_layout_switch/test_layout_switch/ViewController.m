//
//  ViewController.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "DataSource.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *leftLayout;
@property (nonatomic, strong) DataSource *dataSource;
@end

@implementation ViewController

typedef NS_ENUM(NSUInteger, ButtonType) {
    ButtonTypeFill1,
    ButtonTypeFill2,
};


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{5, 5}, {50, 40}};
    btn.tag = ButtonTypeFill1;
    [btn setTitle:@"stack1" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{55, 5}, {50, 40}};
    btn.tag = ButtonTypeFill2;
    [btn setTitle:@"stack2" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

#pragma mark - actions

-(void)onTap:(UIButton *)sender {
    switch (sender.tag) {
        case ButtonTypeFill1: {
            [self.dataSource fillCellType1];
            [self.collectionView reloadData];
        } break;
        case ButtonTypeFill2: {
            [self.dataSource fillCellType2];
            [self.collectionView reloadData];
        } break;
        default:
            break;
    }
}

#pragma mark - getters

-(DataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[DataSource alloc] init];
    }
    return _dataSource;
}

-(UICollectionViewFlowLayout *)leftLayout {
    if (!_leftLayout) {
        _leftLayout = [[UICollectionViewFlowLayout alloc] init];
        _leftLayout.minimumInteritemSpacing = 4;
        _leftLayout.minimumLineSpacing = 4;
        _leftLayout.sectionInset = (UIEdgeInsets){4,0,0,0};
    }
    return _leftLayout;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:self.leftLayout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[Cell1 class] forCellWithReuseIdentifier:reuseIdCell1];
        [_collectionView registerClass:[WideBanner class] forCellWithReuseIdentifier:reuseIdCellWideBanner];
        [_collectionView registerClass:[SquareCell class] forCellWithReuseIdentifier:reuseIdCellSquareCell];
        [_collectionView registerClass:[BigCell class] forCellWithReuseIdentifier:reuseIdCellBigCell];
    }
    return _collectionView;
}

#pragma mark - collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataSource numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<ResultObject> res = [self.dataSource objectByIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[res cellReuseID] forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource objectSizeByIndexPath:indexPath];
}

@end
