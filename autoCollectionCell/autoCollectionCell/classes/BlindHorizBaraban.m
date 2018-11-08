//
//  BlindHorizBaraban.m
//  autoCollectionCell
//
//  Created by Victor Zinets on 11/8/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "BlindHorizBaraban.h"
#import "BlindHorizBarabanCell.h"

@interface BlindHorizBaraban() <UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation BlindHorizBaraban

static NSString *СellId = @"BlindHorizBarabanCell"; // имя/id класса ячейки
static CGFloat const collectionHeight = 22;
static CGFloat const additionalSpace = 7; // расстояние между хедером и коллекцией

- (void)commonInit {
    [self addSubview:self.headerLabel];
    [self addSubview:self.collectionView];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - getters

-(UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.bounds.size.width, 22}];
        _headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.backgroundColor = [UIColor yellowColor];
    }
    return _headerLabel;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =[UICollectionViewFlowLayout new];
        layout.estimatedItemSize = (CGSize){100, collectionHeight};
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){0, self.headerLabel.bounds.size.height + additionalSpace, self.bounds.size.width, collectionHeight}
                                             collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _collectionView.backgroundColor = [UIColor redColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:СellId bundle:nil] forCellWithReuseIdentifier:СellId];
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

-(void)setHeaderTextColor:(UIColor *)headerTextColor {
    _headerTextColor = headerTextColor;
    self.headerLabel.textColor = _headerTextColor;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BlindHorizBarabanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:СellId forIndexPath:indexPath];
    cell.cellTextLabel.text = self.items[indexPath.item];
    return cell;
}

#pragma mark - IB

-(void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    self.headerText = @"Sample header text";
    self.items = @[ @"чистый White", @"светлый Red", @"Black", @"бледный Yellow", @"грязный Purple"];
}

-(CGSize)intrinsicContentSize {
    CGSize sz = self.bounds.size;
    sz.height = self.headerLabel.bounds.size.height + additionalSpace + collectionHeight;
    return sz;
}

@end
