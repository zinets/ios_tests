//
//  ViewController.m
//  testCollL
//
//  Created by Zinets Victor on 3/17/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+MUIColor.h"

#import "Layout.h"
#import "Cell.h"

@interface ViewController () <UICollectionViewDataSource>
@property (nonatomic, strong) Layout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (Layout *)layout {
    if (!_layout) {
        _layout = [Layout new];
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
            _collectionView.backgroundColor = [UIColor redColor];
        [_collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHex:random() & 0xffffff];
    
    return cell;
}

@end
