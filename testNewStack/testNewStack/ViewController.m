//
//  ViewController.m
//  testNewStack
//
//  Created by Zinets Victor on 2/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "StackCell2.h"
#import "StackLayout2.h"

@interface ViewController () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) StackLayout2 *stackLayout;
@end

static NSString *const reuseIdCell2 = @"erbg";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - collection

-(StackLayout2 *)stackLayout {
    if (!_stackLayout) {
        _stackLayout = [StackLayout2 new];
    }
    return _stackLayout;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.stackLayout];
        _collectionView.backgroundColor =[UIColor yellowColor];
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[StackCell2 class] forCellWithReuseIdentifier:reuseIdCell2];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdCell2 forIndexPath:indexPath];
    
    return cell;
}

@end
