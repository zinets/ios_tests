//
//  ViewController.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "StackLayout.h"
#import "StackCell.h"

#import "Utils.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) StackLayout *listLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
}

#pragma mark - collection

- (void)registerCells {
    [self.collectionView registerClass:[StackCell class] forCellWithReuseIdentifier:reuseIdStackCell];
}

- (StackLayout *)listLayout {
    if (!_listLayout) {
        _listLayout = [[StackLayout alloc] init];
    }
    return _listLayout;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.listLayout];
        [self registerCells];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        borderControl(_collectionView);
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdStackCell forIndexPath:indexPath];
    
    return cell;
}

@end
