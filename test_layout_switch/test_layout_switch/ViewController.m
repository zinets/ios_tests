//
//  ViewController.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *leftLayout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{5, 5}, {50, 40}};
    [btn setTitle:@"left" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap1:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{55, 5}, {50, 40}};
    [btn setTitle:@"right" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap2:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

#pragma mark - actions

-(void)onTap1:(id)sender {

}

-(void)onTap2:(id)sender {

}

#pragma mark - getters

-(UICollectionViewFlowLayout *)leftLayout {
    if (!_leftLayout) {
        _leftLayout = [[UICollectionViewFlowLayout alloc] init];
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
    }
    return _collectionView;
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
