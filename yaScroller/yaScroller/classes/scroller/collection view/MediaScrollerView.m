//
//  MediaScrollerView.m
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "MediaScrollerView.h"
#import "MediaScrollerDatasource.h"

@interface MediaScrollerView () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, readonly) MediaScrollerDatasource *internalDataSource;
@end

@implementation MediaScrollerView

@synthesize internalDataSource = _internalDataSource;

- (void)commonInit {
    self.internalDataSource.collectionView = self.collectionView;
    [self addSubview:self.collectionView];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

#pragma mark collection -

- (MediaScrollerDatasource *)internalDataSource {
    if (!_internalDataSource) {
        _internalDataSource = [[MediaScrollerDatasource alloc] init];
    }
    return _internalDataSource;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = self.bounds.size;

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
    }
    return _collectionView;
}

#pragma mark paginating -

- (void)setPaginating:(BOOL)paginating {
    _paginating = paginating;

}

- (void)setOneElementPaginating:(BOOL)oneElementPaginating {
    _oneElementPaginating = oneElementPaginating;

}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;

//    UICollectionViewFlowLayout *layout = (id)self.collectionViewLayout;
//
//    layout.scrollDirection = _scrollDirection;
//    [layout invalidateLayout];
}

#pragma mark dataSource -

- (void)setItems:(NSArray *)items {
    self.internalDataSource.items = items;
}

- (NSArray *)items {
    return self.internalDataSource.items;
}

@end
