//
//  ViewController.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "DataSource.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DataSourceDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout1;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout2;
@property (nonatomic, strong) DataSource *dataSource;
@end

@implementation ViewController

typedef NS_ENUM(NSUInteger, ButtonType) {
    ButtonTypeFill1,
    ButtonTypeFill2,
    ButtonTypeSwitchLayout,
    ButtonTypeInsertBanner,
    ButtonTypeReplaceCells,
    ButtonTypeDeleteBanners,
};


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:(CGRect){{0, 0}, {320, 44}}];
    scroller.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:scroller];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{5, 5}, {55, 40}};
    btn.tag = ButtonTypeFill1;
    [btn setTitle:@"stack1" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [scroller addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{65, 5}, {55, 40}};
    btn.tag = ButtonTypeFill2;
    [btn setTitle:@"stack2" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [scroller addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{120, 5}, {60, 40}};
    btn.tag = ButtonTypeSwitchLayout;
    [btn setTitle:@"switch" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [scroller addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{185, 5}, {60, 40}};
    btn.tag = ButtonTypeInsertBanner;
    [btn setTitle:@"insert" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [scroller addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{240, 5}, {60, 40}};
    btn.tag = ButtonTypeReplaceCells;
    [btn setTitle:@"change" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [scroller addSubview:btn];
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){{305, 5}, {60, 40}};
    btn.tag = ButtonTypeDeleteBanners;
    [btn setTitle:@"delete" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [scroller addSubview:btn];
    
    CGSize sz = scroller.bounds.size;
    sz.width = btn.frame.origin.x + btn.frame.size.width;
    scroller.contentSize = sz;
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
        case ButtonTypeSwitchLayout:
            [self.dataSource fillCellType2];
            [self.collectionView setCollectionViewLayout:self.layout2 animated:YES];
            break;
        case ButtonTypeInsertBanner:
            [self.dataSource insertWideBanner];
            break;
        case ButtonTypeReplaceCells:
            [self.dataSource replaceCells];
            break;
        case ButtonTypeDeleteBanners:
            [self.dataSource deleteBanners];
            break;
        default:
            break;
    }
}

#pragma mark - getters

-(DataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[DataSource alloc] init];
        _dataSource.delegate = self;
    }
    return _dataSource;
}

-(UICollectionViewFlowLayout *)layout1 {
    if (!_layout1) {
        _layout1 = [[UICollectionViewFlowLayout alloc] init];
        _layout1.minimumInteritemSpacing = 4;
        _layout1.minimumLineSpacing = 4;
        _layout1.sectionInset = (UIEdgeInsets){4,0,0,0};
    }
    return _layout1;
}

-(UICollectionViewFlowLayout *)layout2 {
    if (!_layout2) {
        _layout2 = [[UICollectionViewFlowLayout alloc] init];
        _layout2.minimumInteritemSpacing = 0;
        _layout2.minimumLineSpacing = 8;
        _layout2.sectionInset = (UIEdgeInsets){0,0,0,0};
    }
    return _layout2;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        CGRect frm = self.view.bounds;
        frm.origin.y = 44;
        frm.size.height -= 44;
        _collectionView = [[UICollectionView alloc] initWithFrame:frm
                                             collectionViewLayout:self.layout1];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s\n%@", __PRETTY_FUNCTION__, [[collectionView cellForItemAtIndexPath:indexPath] description]);
}

#pragma mark - datasource delegation

- (void)searchDataSource:(id)sender didAddData:(NSArray <NSIndexPath *> *)newIndexes removedData:(NSArray <NSIndexPath *> *)removedIndexes {
    [self.collectionView performBatchUpdates:^{
        if (removedIndexes.count > 0) {
            [self.collectionView deleteItemsAtIndexPaths:removedIndexes];
        }

        if (newIndexes.count > 0) {
            [self.collectionView insertItemsAtIndexPaths:newIndexes];
        }
    } completion:^(BOOL finished) {
        
    }];
}

@end
