//
//  SPager.m
//
//  Created by Victor Zinets on 4/16/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "SPager.h"
#import "SPagerCell.h"
#import "HorizontalPageIndicator.h"
#import "UIColor+MUIColor.h"


@implementation PagerItem

+(instancetype)newPagerItemWithTitle:(NSString *)title descr:(NSString *)descr image:(NSString *)imageUrl {
    PagerItem *item = [PagerItem new];
    item.itemTitle = title;
    item.itemDescription = descr;
    item.itemImageUrl = imageUrl;
    return item;
}

@end

@interface SPager () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSTimer *slideTimer;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HorizontalPageIndicator *pageIndicator;
@end

@implementation SPager

CGFloat const sideOffset = 40; // это ж идея, когда слайд шире окна для красоты листания
CGFloat const pageIndicatorHeight = 10;
CGFloat const timerInterval = 5.;

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
        pt.x = currentPage * (self.collectionView.bounds.size.width + 2 * sideOffset);
        [self.collectionView setContentOffset:pt animated:YES];
    }
    
    self.pageIndicator.currentPage = _currentPage;
    [self startAnimating];
}

#pragma mark page indicator -

-(HorizontalPageIndicator *)pageIndicator {
    if (!_pageIndicator) {
        CGRect frm = self.bounds;
        frm.origin.y = frm.size.height - pageIndicatorHeight;
        frm.size.height = pageIndicatorHeight;
        
        _pageIndicator = [[HorizontalPageIndicator alloc] initWithFrame:frm];
        _pageIndicator.backgroundColor = [UIColor clearColor];
        _pageIndicator.spacing = 8; {
            UIView *mark = [[UIView alloc] initWithFrame:(CGRect){0, 0, 6, 6}];
            mark.layer.cornerRadius = 3;
            mark.backgroundColor = [UIColor whiteColor];
            _pageIndicator.selectedMarkView = mark;
            
            mark = [[UIView alloc] initWithFrame:(CGRect){0, 0, 6, 6}];
            mark.layer.cornerRadius = 3;
            mark.backgroundColor = [UIColor colorWithHex:0x3e4343];
            _pageIndicator.inactiveMarkView = mark;
        }
    }
    return _pageIndicator;
}

#pragma mark datasource -

-(void)setDataSource:(NSArray<PagerItem *> *)dataSource {
//    _dataSource = [dataSource copy]; ?
    _dataSource = dataSource;
    
    self.pageIndicator.numberOfPages = _dataSource.count;
    self.currentPage = 0;
}

#pragma mark collection -

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = (UIEdgeInsets){0, -sideOffset, 0, -sideOffset};
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
        
        [_collectionView registerNib:[UINib nibWithNibName:@"SPagerCell" bundle:nil] forCellWithReuseIdentifier:@"SPagerCell"];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SPagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SPagerCell" forIndexPath:indexPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)c forItemAtIndexPath:(NSIndexPath *)indexPath {
    SPagerCell *cell = (id)c;
    PagerItem *item = self.dataSource[indexPath.item];
    cell.itemTitle = item.itemTitle;
    cell.itemDescription = item.itemDescription;
    cell.itemImageUrl = item.itemImageUrl;   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize sz = collectionView.bounds.size;
    sz.width += 2 * sideOffset;
    
    return sz;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopAnimating];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // это работает; формально правильно, фактически при небольших сдвигах имеем дерганый возврат к начальному положению - фу-фу-фу
//    CGFloat x = targetContentOffset->x;
//    NSInteger page = x / scrollView.bounds.size.width;
//    NSInteger d = page - self.currentPage;
//    if (ABS(d) > 1) {
//        page = self.currentPage + (d > 0 ? 1 : -1); // чойта коряво как-то :)
//    }
//
//    x = page * (scrollView.bounds.size.width + 2 * sideOffset);
    
    
    // формально неправильно - заканчиваем скрол, даже если инерции недостаточно; но пох, потому что выглядит лучшее
    NSInteger page = self.currentPage + (velocity.x > 0 ? 1 : -1);
    page = MIN(self.dataSource.count - 1, MAX(0, page));
    CGFloat x = page * (scrollView.bounds.size.width + 2 * sideOffset);
    
    targetContentOffset->x = x;
    self.currentPage = page;
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


@end
