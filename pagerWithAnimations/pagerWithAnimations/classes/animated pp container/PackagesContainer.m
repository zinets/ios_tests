//
//  PackagesContainer.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PackagesContainer.h"
#import "PackagesContainerLayout.h"
#import "PackageCell.h"

@interface PackagesContainer () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation PackagesContainer

#define CELL_ID @"package_cell_id"

-(void)commonInit {
    [self addSubview:self.collectionView];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

#pragma mark getters -

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        PackagesContainerLayout *layout = [PackagesContainerLayout new];
        layout.itemSize = (CGSize){180, 180};
        layout.selectedItemSize = (CGSize){244, 244};        
        layout.minimumInterItemSpacing = 16;
        
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        CGFloat r = self.bounds.size.width - 40 - 244;
//
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.contentInset = (UIEdgeInsets){0, 40, 0, self.bounds.size.width - 180 - 40};
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"PackageCell" bundle:nil] forCellWithReuseIdentifier:CELL_ID];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

#pragma mark collection -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PackageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    return cell;
}

@end
