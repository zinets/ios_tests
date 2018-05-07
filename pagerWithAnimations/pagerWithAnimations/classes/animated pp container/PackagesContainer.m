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

@interface PackagesContainer () <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSInteger indexOfElementBeforeScroll;
    CGFloat initialContentOffset, maxContentOffset, minContentOffset;
}
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
        layout.leftPadding = 40;
        
        initialContentOffset = CGFLOAT_MAX;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"PackageCell" bundle:nil] forCellWithReuseIdentifier:CELL_ID];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

#pragma mark collection -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PackageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    PackagesContainerLayout *layout = (id)collectionView.collectionViewLayout;    
    CGFloat xOffset = indexPath.item * (layout.itemSize.width + layout.minimumInterItemSpacing) - layout.leftPadding;
    [collectionView setContentOffset:(CGPoint){xOffset, 0} animated:YES];
}

#pragma mark scrolling -

// следующая поебень нужна для ограничения скрола пакетов на 1 элемент; если просто выравнивать после скрола ячейку - то достаточно targetContentOffsetForProposedContentOffset, но если крутнуть сильно - там все выровняется, но с 0й ячейки можно пролистать сразу до 2й -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    PackagesContainerLayout *layout = (id)self.collectionView.collectionViewLayout;
    indexOfElementBeforeScroll = round((scrollView.contentOffset.x + scrollView.contentInset.left) / (layout.itemSize.width + layout.minimumInterItemSpacing));
    
    initialContentOffset = scrollView.contentOffset.x;
    minContentOffset = initialContentOffset - (layout.itemSize.width + layout.minimumInterItemSpacing);
    maxContentOffset = initialContentOffset + (layout.itemSize.width + layout.minimumInterItemSpacing);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (initialContentOffset < CGFLOAT_MAX) {
        PackagesContainerLayout *layout = (id)self.collectionView.collectionViewLayout;
        CGPoint pt = scrollView.contentOffset;
        pt.x = MIN(MAX(pt.x, minContentOffset), maxContentOffset);
        [scrollView setContentOffset:pt];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (targetContentOffset->x > initialContentOffset) {
        indexOfElementBeforeScroll++;
    } else if (targetContentOffset->x < initialContentOffset) {
        indexOfElementBeforeScroll--;
    }
    
    PackagesContainerLayout *layout = (id)self.collectionView.collectionViewLayout;
    CGFloat xOffset = indexOfElementBeforeScroll * (layout.itemSize.width + layout.minimumInterItemSpacing) - self.collectionView.contentInset.left;
    targetContentOffset->x = xOffset;
    
    initialContentOffset = CGFLOAT_MAX;
}

@end
