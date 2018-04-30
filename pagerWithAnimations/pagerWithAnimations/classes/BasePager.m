//
//  BasePager.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "BasePager.h"
#import "HorizontalPageIndicator.h"
#import "UIColor+MUIColor.h"

@interface BasePager() {
    NSTimer *slideTimer;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HorizontalPageIndicator *pageIndicator;
@end

CGFloat const pageIndicatorHeight = 10;
CGFloat const timerInterval = 10;

@implementation BasePager

- (void)commonInit {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageIndicator];
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

#pragma mark datasource -

-(void)setDataSource:(NSArray *)dataSource {
    //    _dataSource = [dataSource copy]; ?
    _dataSource = dataSource;
    
    self.pageIndicator.numberOfPages = _dataSource.count;
    self.currentPage = 0;
}

#pragma mark page indicator -

-(HorizontalPageIndicator *)pageIndicator {
    if (!_pageIndicator) {
        CGRect frm = self.bounds;
        frm.origin.y = frm.size.height - pageIndicatorHeight;
        frm.size.height = pageIndicatorHeight;
        
        _pageIndicator = [[HorizontalPageIndicator alloc] initWithFrame:frm];
        _pageIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _pageIndicator.backgroundColor = [UIColor clearColor];
        _pageIndicator.spacing = 8; {
            UIView *mark = [[UIView alloc] initWithFrame:(CGRect){0, 0, 6, 6}];
            mark.layer.cornerRadius = 3;
#warning // todo colors of hor.scroll indicator
            //            mark.backgroundColor = [UIColor colorWithHex:Aprnc.kPPPageMarkSelected];
            _pageIndicator.selectedMarkView = mark;
            
            mark = [[UIView alloc] initWithFrame:(CGRect){0, 0, 6, 6}];
            mark.layer.cornerRadius = 3;
            //            mark.backgroundColor = [UIColor colorWithHex:Aprnc.kPPPageMark];
            _pageIndicator.inactiveMarkView = mark;
        }
    }
    return _pageIndicator;
}

#pragma mark animation -

- (void)startAnimating {
    [self stopAnimating];
    
    slideTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
}

- (void)stopAnimating {
    [slideTimer invalidate];
}

- (void)onTimer:(id)timer {
    self.currentPage++;
}

#pragma mark current page -

-(void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage < 0) {
        currentPage = self.dataSource.count - 1;
    } else if (currentPage >= self.dataSource.count) {
        currentPage = 0;
    }
    //    currentPage = MIN(MAX(0, currentPage), self.dataSource.count - 1); или можно просто органичивать прокрутку
    if (currentPage != _currentPage) {
        _currentPage = currentPage;
        
        CGPoint pt = self.collectionView.contentOffset;
        pt.x = currentPage * (self.collectionView.bounds.size.width + 2 * self.sideOffset);
        [self.collectionView setContentOffset:pt animated:YES];
    }
    
    self.pageIndicator.currentPage = _currentPage;
    [self startAnimating];
}

#pragma mark collection -

- (NSString *)cellClassName {
    return nil;
}

- (CGFloat)sideOffset {
    return 0;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = (UIEdgeInsets){0, -self.sideOffset, 0, -self.sideOffset};
        layout.minimumLineSpacing =
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect frm = self.bounds;
        frm.size.height -= pageIndicatorHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:frm collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        [_collectionView registerNib:[UINib nibWithNibName:[self cellClassName] bundle:nil] forCellWithReuseIdentifier:[self cellClassName]];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)applyData:(id)itemData toCell:(UICollectionViewCell *)cell {
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self applyData:self.dataSource[indexPath.item] toCell:cell];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellClassName] forIndexPath:indexPath];
    return cell;
}

#pragma mark scrollview -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAnimating];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // формально неправильно - заканчиваем скрол, даже если инерции недостаточно; но пох, потому что выглядит лучшее
    NSInteger page = self.currentPage + (velocity.x > 0 ? 1 : -1);
    page = MIN(self.dataSource.count - 1, MAX(0, page));
    CGFloat x = page * (scrollView.bounds.size.width + 2 * self.sideOffset);
    
    targetContentOffset->x = x;
    self.currentPage = page;
}

@end
