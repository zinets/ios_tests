//
//  ViewController.m
//  testLayoutSwitch
//
//  Created by Zinets Victor on 2/19/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "CellType1.h"
#import "CellType2.h"

#import "LeftLayout.h"
#import "RightLayout.h"

typedef NS_ENUM(NSUInteger, Layout) {
    Layout1,
    Layout2,
};

@interface ViewController () 
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LeftLayout *leftLayout;
@property (nonatomic, strong) RightLayout *rightLayout;
@property (nonatomic, assign) Layout layoutType;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:(CGRect){{0, 0}, {30, 30}}];
    [btn setTitle:@"1" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(setType1) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    btn = [[UIButton alloc] initWithFrame:(CGRect){{0, 0}, {30, 30}}];
    [btn setTitle:@"2" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(setType2) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItems = @[item1, item2];
    
    
    [self.view addSubview:self.collectionView];
}

- (void)setType1 {
    self.layoutType = Layout1;
}

- (void)setType2 {
    self.layoutType = Layout2;
}

-(void)setLayoutType:(Layout)layoutType {
    if (layoutType != _layoutType) {
        _layoutType = layoutType;
        UICollectionViewLayout *l;
        switch (_layoutType) {
            case Layout1:
                l = self.leftLayout;
                break;
            case Layout2:
                l = self.rightLayout;
                break;
        }
        
        NSArray *arr = [self.collectionView indexPathsForVisibleItems];
        if (arr.count > 0) {
            [self.collectionView selectItemAtIndexPath:[arr firstObject] animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
        }

        [self.collectionView setCollectionViewLayout:l animated:YES completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
        [self.collectionView reloadItemsAtIndexPaths:arr];
    }
}

#pragma mark - collection

-(LeftLayout *)leftLayout {
    if (!_leftLayout) {
        _leftLayout = [[LeftLayout alloc] init];
        _leftLayout.itemSize = (CGSize){90, 90};
        _leftLayout.sectionInset = (UIEdgeInsets){10, 10, 10, 10};
        _leftLayout.minimumInteritemSpacing = _leftLayout.minimumLineSpacing = 8;
    }
    return _leftLayout;
}

-(RightLayout *)rightLayout {
    if (!_rightLayout) {
        _rightLayout = [[RightLayout alloc] init];
        _rightLayout.itemSize = (CGSize){140, 140};
        _rightLayout.sectionInset = (UIEdgeInsets){10, 10, 10, 10};
        _rightLayout.minimumInteritemSpacing = _leftLayout.minimumLineSpacing = 8;
    }
    return _rightLayout;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.leftLayout];
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[CellType1 class] forCellWithReuseIdentifier:[CellType1 description]];
        [_collectionView registerClass:[CellType2 class] forCellWithReuseIdentifier:[CellType2 description]];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.layoutType) {
        case Layout1: {
            CellType1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CellType1 description] forIndexPath:indexPath];
            cell.title = [NSString stringWithFormat:@"small #%@", @(indexPath.item)];
            return cell;
        }
        case Layout2: {
            CellType2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CellType2 description] forIndexPath:indexPath];
            cell.title = [NSString stringWithFormat:@"big cell #%@", @(indexPath.item)];
            return cell;
        }
    }

}

@end
