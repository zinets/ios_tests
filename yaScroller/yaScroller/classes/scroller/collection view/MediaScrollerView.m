//
//  MediaScrollerView.m
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "MediaScrollerView.h"
#import "MediaScrollerDatasource.h"
#import "MediaScrollerViewLayout.h"

@interface MediaScrollerView () <UICollectionViewDelegateFlowLayout> {
    CGPoint offsetAtBeginScrolling;
}
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
        MediaScrollerViewLayout *layout = [MediaScrollerViewLayout new];

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

    UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;

    layout.scrollDirection = _scrollDirection;
    [layout invalidateLayout];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.oneElementPaginating) {
        offsetAtBeginScrolling = scrollView.contentOffset;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.paginating) {
        UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;

        CGFloat v = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? targetContentOffset->x : targetContentOffset->y;
        CGFloat pageWidth = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (layout.itemSize.width + layout.minimumInteritemSpacing) : (layout.itemSize.height + layout.minimumLineSpacing);
        if (self.oneElementPaginating) {
            CGFloat startOffset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? offsetAtBeginScrolling.x : offsetAtBeginScrolling.y;
            CGFloat vel = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? velocity.x : velocity.y;
            CGFloat m;
            if (vel >= 0) {
                m = MIN(pageWidth, v - startOffset);
            } else {
                m = MAX(-pageWidth, v - startOffset);
            }
            v = startOffset + m + pageWidth / 2;
        }

        NSInteger pageIndex = (NSInteger) (v / pageWidth);
        CGFloat newOffset = pageWidth * pageIndex;

        self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (targetContentOffset->x = newOffset) : (targetContentOffset->y = newOffset);
    }
}

#pragma mark dataSource -

- (void)setItems:(NSArray *)items {
    self.internalDataSource.items = items;
}

- (NSArray *)items {
    return self.internalDataSource.items;
}

@end
