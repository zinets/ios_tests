//
// Created by Victor Zinets on 5/14/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "HexagonCollectionView.h"
#import "HexagonCollectionLayout.h"
#import "HexagonCell.h"

#import "UIColor+MUIColor.h"


@interface HexagonCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) HexagonCollectionLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HexagonCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    [self addSubview:self.collectionView];
}

#pragma mark getters -

- (HexagonCollectionLayout *)layout {
    if (!_layout) {
        _layout = [HexagonCollectionLayout new];
        _layout.columnsCount = NSAutocalculatedCount;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor clearColor];
        
//        [_collectionView registerClass:[HexagonCell class] forCellWithReuseIdentifier:[HexagonCell description]];
        [_collectionView registerNib:[UINib nibWithNibName:@"HexagonCell" bundle:nil] forCellWithReuseIdentifier:@"HexagonCell"];

        _collectionView.dataSource = self;
    }
    return _collectionView;
}

#pragma mark collection -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HexagonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HexagonCell" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor colorWithHex:arc4random() & 0xffffff] colorWithAlphaComponent:1];
    cell.label.text = [NSString stringWithFormat:@"%d", indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // посчитать куда попали и посигналить выше
    // допустим посчитали indexPath
    if (self.delegate) {
        [self.delegate hexagonalCollectionView:self didSelectItemAtIndexPath:indexPath];
    }
}

@end
