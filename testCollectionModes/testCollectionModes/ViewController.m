//
//  ViewController.m
//  testCollectionModes
//
//  Created by Zinets Victor on 1/29/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "Layout.h"
#import "CollectionViewCell.h"

#import "Utils.h"
#import "UIColor+MUIColor.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {

}
@property (nonatomic, assign) BOOL gridMode;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifier2 = @"CellExt";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [btn setTitle:@"switch" forState:(UIControlStateNormal)];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(switch) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.7];
    [self.collectionView registerClass:[CollectionViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[CollectionViewCellExt class]
            forCellWithReuseIdentifier:reuseIdentifier2];
    
    self.gridMode = YES;
}

- (void)switch {
    self.gridMode = !self.gridMode;
}

#pragma mark - lazy

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        Layout *layout = [Layout new];        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.7];
    }
    return _collectionView;
}

#pragma mark - collection delegating

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId;
    if (indexPath.item % 4 == 1) {
        cellId = reuseIdentifier2;
    } else {
        cellId = reuseIdentifier;
    }
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.title = [NSString stringWithFormat:@"cell: %@:%@", @(indexPath.section), @(indexPath.item)];
    
    NSString *fn = [NSString stringWithFormat:@"0%.2ld.jpg", (long)indexPath.item];
    UIImage *img = [UIImage imageNamed:fn];
    [cell setPhoto:img];
    return cell;
}

- (NSIndexPath *)nearestToCenterOfCollectionView:(UICollectionView *)cv {
    NSIndexPath *res = nil;
    CGPoint center = (CGPoint){cv.bounds.origin.x + cv.bounds.size.width / 2, cv.bounds.origin.y + cv.bounds.size.height / 2};
    CGFloat minDist = CGFLOAT_MAX;
    for (NSIndexPath *index in [cv indexPathsForVisibleItems]) {
        UICollectionViewLayoutAttributes *attr = [cv layoutAttributesForItemAtIndexPath:index];
        CGFloat x = center.x - attr.center.x;
        CGFloat y = center.y - attr.center.y;
        CGFloat dist = sqrt(x * x + y * y);
        if (dist < minDist) {
            res = index;
            minDist = dist;
        }
    };
    
    return res;
}

-(void)setGridMode:(BOOL)gridMode {
    if (_gridMode != gridMode) {
        _gridMode = gridMode;

        NSIndexPath *idx = [self nearestToCenterOfCollectionView:self.collectionView];
        if (idx) {
            [self.collectionView selectItemAtIndexPath:idx animated:NO scrollPosition:(UICollectionViewScrollPositionNone)];
        }
        [self.collectionView performBatchUpdates:^{
            [self.collectionView reloadData];
            //            [self.collectionView.collectionViewLayout invalidateLayout];
            [self.collectionView setCollectionViewLayout:[/*UICollectionViewFlow*/Layout new]
                                                animated:YES];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gridMode) {
        if (indexPath.item == 3)
            return (CGSize){145, 90};
        else
            return (CGSize){145, 178};
    } else {
        return (CGSize){145*2, 178*2};
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return (UIEdgeInsets){11, 11, 11, 11};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.gridMode = !self.gridMode;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

@end
