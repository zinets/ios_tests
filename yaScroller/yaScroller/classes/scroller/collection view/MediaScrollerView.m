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

#define TAP_ZONE_WIDTH 50.

@interface MediaScrollerView () <UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate> {
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

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark tap to scroll -

- (void)setTapToScroll:(BOOL)tapToScroll {
    if (tapToScroll) {
        if (!tapGestureRecognizer) {
            tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToScroll:)];
            tapGestureRecognizer.delegate = self;
            [self addGestureRecognizer:tapGestureRecognizer];
        }
        tapGestureRecognizer.enabled = YES;
    } else {
        tapGestureRecognizer.enabled = NO;
    }
    _tapToScroll = tapToScroll;
}

- (void)tapToScroll:(UITapGestureRecognizer *)sender {
    UIScrollView *scroller = self.collectionView;
    CGPoint pt = [sender locationInView:scroller];
    CGPoint offset = scroller.contentOffset;
    UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;

    NSInteger pageIndex;
    CGFloat pageWidth;

    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        pageWidth = layout.itemSize.width + layout.minimumInteritemSpacing;
        pageIndex = (NSInteger) (offset.x / pageWidth);
        if ((pt.x < offset.x + TAP_ZONE_WIDTH)) {
            if (!self.endlessScrolling) {
                pageIndex = MAX(0, pageIndex - 1);
            } else {
                pageIndex--;
            }
            offset.x = pageIndex * pageWidth;
            [scroller setContentOffset:offset animated:YES];
        } else if (pt.x > offset.x + scroller.bounds.size.width - TAP_ZONE_WIDTH) {
            if (!self.endlessScrolling) {
                pageIndex = MIN(pageIndex + 1, self.internalDataSource.items.count - 1);
            } else {
                pageIndex++;
            }
            offset.x = pageIndex * pageWidth;
            [scroller setContentOffset:offset animated:YES];
        }
    } else {
        pageWidth = layout.itemSize.height + layout.minimumLineSpacing;
        pageIndex = (NSInteger) (offset.y / pageWidth);
        if ((pt.y < offset.y + TAP_ZONE_WIDTH)) {
            if (!self.endlessScrolling) {
                pageIndex = MAX(0, pageIndex - 1);
            } else {
                pageIndex--;
            }
            offset.y = pageIndex * pageWidth;
            [scroller setContentOffset:offset animated:YES];
        } else if (pt.y > offset.y + scroller.bounds.size.height - TAP_ZONE_WIDTH) {
            if (!self.endlessScrolling) {
                pageIndex = MIN(pageIndex + 1, self.internalDataSource.items.count - 1);
            } else {
                pageIndex++;
            }
            offset.y = pageIndex * pageWidth;
            [scroller setContentOffset:offset animated:YES];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL res = NO;

    if (self.internalDataSource.items.count < 2)
        return res;

    UIScrollView *scroller = self.collectionView;
    CGPoint pt = [touch locationInView:scroller];
    CGPoint offset = scroller.contentOffset;

    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        res = (pt.x < offset.x + TAP_ZONE_WIDTH)
                || (pt.x > offset.x + scroller.bounds.size.width - TAP_ZONE_WIDTH);
    } else {
        res = (pt.y < offset.y + TAP_ZONE_WIDTH)
                || (pt.y > offset.y + scroller.bounds.size.height - TAP_ZONE_WIDTH);
    }
    return res;
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
        layout.minimumLineSpacing =
        layout.minimumInteritemSpacing = 0;

        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.decelerationRate = 0;
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

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.paginating) {
        UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;

        CGFloat proposedOffset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? targetContentOffset->x : targetContentOffset->y;
        CGFloat pageWidth = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (layout.itemSize.width + layout.minimumInteritemSpacing) : (layout.itemSize.height + layout.minimumLineSpacing);
        CGFloat vel = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? velocity.x : velocity.y;
        CGFloat offset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y;

        NSInteger pageIndex = (NSInteger) ((proposedOffset + pageWidth / 2)/ pageWidth);
        if (self.oneElementPaginating) {
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
    if (self.endlessScrolling) {
        CGFloat minValue = 0;
        CGFloat maxValue = scrollView.contentSize.width - scrollView.bounds.size.width;
        CGFloat curX = scrollView.contentOffset.x;
        CGPoint pt = scrollView.contentOffset;
        if (curX < minValue) {
            pt.x += scrollView.bounds.size.width;
            scrollView.contentOffset = pt;
            [self.internalDataSource shiftDataRight];
        } else if (curX > maxValue) {
            pt.x -= scrollView.bounds.size.width;
            scrollView.contentOffset = pt;
            [self.internalDataSource shiftDataLeft];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;

    CGFloat pageWidth = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (layout.itemSize.width + layout.minimumInteritemSpacing) : (layout.itemSize.height + layout.minimumLineSpacing);
    CGFloat offset = self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? scrollView.contentOffset.x : scrollView.contentOffset.y;

    NSInteger pageIndex = (NSInteger) (offset + pageWidth / 2) / pageWidth;
    CGPoint pt = scrollView.contentOffset;
    self.scrollDirection == UICollectionViewScrollDirectionHorizontal ? (pt.x = pageIndex * pageWidth) : (pt.y = pageIndex * pageWidth);
    [scrollView setContentOffset:pt animated:YES];
}

#pragma mark dataSource -

- (void)setItems:(NSArray *)items {
    self.internalDataSource.items = items;
}

- (NSArray *)items {
    return self.internalDataSource.items;
}

#pragma mark collection delegate -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(mediaScroller:didSelectItem:)]) {
        id obj = self.internalDataSource.items[indexPath.item];
        [self.delegate mediaScroller:self didSelectItem:obj];
    }
    NSLog(@"%@ %@", indexPath, self.internalDataSource.items[indexPath.item]);
}


- (UIImage *)image {
    return [self.internalDataSource image];
}

- (void)updateLayout {
    [self.collectionView.collectionViewLayout invalidateLayout];
}

@end
