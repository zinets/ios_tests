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
//    CGPoint offsetAtBeginScrolling;
    UITapGestureRecognizer *tapGestureRecognizer;
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

#pragma mark setters -

- (void)setTapToScroll:(BOOL)tapToScroll {

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

#pragma mark scroller -

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if (self.oneElementPaginating) {
//        offsetAtBeginScrolling = scrollView.contentOffset;
//    }
//}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.paginating) {
        UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;

        CGFloat proposedOffset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? targetContentOffset->x : targetContentOffset->y;
        CGFloat pageWidth = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (layout.itemSize.width + layout.minimumInteritemSpacing) : (layout.itemSize.height + layout.minimumLineSpacing);
        CGFloat vel = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? velocity.x : velocity.y;
        CGFloat offset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y;

        NSInteger pageIndex = (NSInteger) ((proposedOffset + pageWidth / 2)/ pageWidth);
        if (self.oneElementPaginating) {
            // можно так - но с лишним методом и сохранением в переменную оффсета перед движением
//            CGFloat startOffset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? offsetAtBeginScrolling.x : offsetAtBeginScrolling.y;
//            CGFloat vel = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? velocity.x : velocity.y;
//            CGFloat m;
//            if (vel >= 0) {
//                m = MIN(pageWidth, proposedOffset - startOffset);
//            } else {
//                m = MAX(-pageWidth, proposedOffset - startOffset);
//            }
//            proposedOffset = startOffset + m + pageWidth / 2;

            // можно так - используя тот факт, что для 1страничного перелистывания нужно знать только направление листания
            NSInteger curIndex = (NSInteger) (offset / pageWidth);
            if (vel > 0) {
                pageIndex = curIndex + 1;
            } else if (vel < 0){
                pageIndex = curIndex;
            }
        }

        CGFloat newOffset = pageWidth * pageIndex;

        self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (targetContentOffset->x = newOffset) : (targetContentOffset->y = newOffset);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.endlessScrolling && NO) {
        CGFloat minValue = 0;
        CGFloat maxValue = scrollView.contentSize.width - scrollView.bounds.size.width;
        CGFloat curX = scrollView.contentOffset.x;
        CGPoint pt = scrollView.contentOffset;
        if (curX < minValue) {
            NSLog(@"%@", NSStringFromCGPoint(pt));
            NSMutableArray *data = [self.internalDataSource.items mutableCopy];

            pt.x += scrollView.bounds.size.width;
            scrollView.contentOffset = pt;

            id lastObject = [data lastObject];
            [data removeObject:lastObject];
            [data insertObject:lastObject atIndex:0];

            [UIView setAnimationsEnabled:NO];
            self.internalDataSource.items = data;
            [UIView setAnimationsEnabled:YES];
        } else if (curX > maxValue) {
            NSMutableArray *data = [self.internalDataSource.items mutableCopy];

            pt.x -= scrollView.bounds.size.width;
            scrollView.contentOffset = pt;

            id firstObject = [data firstObject];
            [data removeObject:firstObject];
            [data addObject:firstObject];

            [UIView setAnimationsEnabled:NO];
            self.internalDataSource.items = data;
            [UIView setAnimationsEnabled:YES];
        }
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
