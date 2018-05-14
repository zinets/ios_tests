//
// Created by Victor Zinets on 5/14/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "HexagonCollectionView.h"
#import "HexagonCollectionLayout.h"
#import "HexagonalCollectionDatasource.h"

#import "UIColor+MUIColor.h"


@interface HexagonCollectionView() <UICollectionViewDelegate> 
@property (nonatomic, strong) HexagonCollectionLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HexagonalCollectionDatasource *dataSource;
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
        [_collectionView registerNib:[UINib nibWithNibName:@"HexagonCell" bundle:nil] forCellWithReuseIdentifier:@"HexagonCell"];

        _collectionView.delegate = self;
        
        _dataSource = [HexagonalCollectionDatasource new];
        _dataSource.collectionView = _collectionView;
    }
    return _collectionView;
}

-(void)setData:(NSArray *)data {
    self.dataSource.items = [data copy];
}

#pragma mark collection -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // посчитать куда попали и посигналить выше
    // допустим посчитали indexPath
    if (self.delegate) {
        [self.delegate hexagonalCollectionView:self didSelectItemAtIndexPath:indexPath];
    }
}

@end
