//
//  ViewController.m
//  testEndlessScroll
//
//  Created by Zinets Victor on 2/9/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableArray <UIColor *>*_dataSource;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, readonly) NSArray <UIColor *>*dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSource = [NSMutableArray arrayWithArray:
            @[[UIColor redColor],
                    [UIColor yellowColor],
                    [UIColor blueColor],
                    [UIColor greenColor],
                    [UIColor brownColor],
                    [UIColor darkGrayColor]
            ]];

    [self.view addSubview:self.collectionView];
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = (CGSize){60, 270};
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){{0, 50}, {320, 270}}
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.backgroundColor = self.dataSource[indexPath.item];
    CGFloat x = cell.center.x - collectionView.contentOffset.x;
    cell.centerPos = (x - 160) / 65;
    cell.colors = @[self.dataSource[indexPath.item], [UIColor grayColor]];
    return cell;
}

#pragma mark - scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat minValue = 0;
    CGFloat maxValue = scrollView.contentSize.width - scrollView.bounds.size.width;
    CGFloat curX = scrollView.contentOffset.x;
    CGPoint pt = scrollView.contentOffset;
    if (curX < minValue) {
        pt.x += 60 + 5;
        scrollView.contentOffset = pt;

        id lastObject = [_dataSource lastObject];
        [_dataSource removeObject:lastObject];
        [_dataSource insertObject:lastObject atIndex:0];
        [self.collectionView reloadData];
    } else if (curX > maxValue) {
        pt.x -= 60 + 5;
        scrollView.contentOffset = pt;

        id firstObject = [_dataSource firstObject];
        [_dataSource removeObject:firstObject];
        [_dataSource addObject:firstObject];
        [self.collectionView reloadData];
    }

    [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(CollectionViewCell *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = obj.center.x - scrollView.contentOffset.x;
        obj.centerPos = (x - 160) / 65;
    }];
}

@end
