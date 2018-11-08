//
//  BlindHorizBaraban.m
//  autoCollectionCell
//
//  Created by Victor Zinets on 11/8/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "BlindHorizBaraban.h"
#import "BlindHorizBarabanLayout.h"
#import "BlindHorizBarabanCell.h"

@interface BlindHorizBaraban() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation BlindHorizBaraban

static NSString *СellId = @"BlindHorizBarabanCell"; // имя/id класса ячейки

#define headerHeight 22
#define additionalSpace 7 // расстояние между хедером и коллекцией
#define collectionHeight 22

- (void)commonInit {
//    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.headerLabel];
    [self.headerLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.headerLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.headerLabel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.headerLabel.heightAnchor constraintEqualToConstant:headerHeight].active = YES;
    
    [self addSubview:self.collectionView];
    [self.collectionView.topAnchor constraintEqualToAnchor:self.headerLabel.bottomAnchor constant:additionalSpace].active = YES;
    [self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.collectionView.heightAnchor constraintEqualToConstant:collectionHeight].active = YES;
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
        _headerLabel = [UILabel new];
        _headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headerLabel;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        BlindHorizBarabanLayout *layout =[BlindHorizBarabanLayout new];
        layout.estimatedItemSize = (CGSize){100, collectionHeight};
                
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.contentInset = (UIEdgeInsets){0, 0, 0, 0};
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        
        [_collectionView registerNib:[UINib nibWithNibName:СellId bundle:nil] forCellWithReuseIdentifier:СellId];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

-(void)setHeaderTextColor:(UIColor *)headerTextColor {
    _headerTextColor = headerTextColor;
    self.headerLabel.textColor = _headerTextColor;
}

-(void)setHeaderText:(NSString *)headerText {
    _headerText = headerText;
    self.headerLabel.text = _headerText;
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
    
    // на время редактирования в IB делаем видимыми границы контрола/ов
    self.headerLabel.backgroundColor = [UIColor grayColor];
    self.collectionView.backgroundColor = [UIColor grayColor];
    self.layer.borderColor = [UIColor greenColor].CGColor;
    self.layer.borderWidth = 1;
}

-(CGSize)intrinsicContentSize {
    CGSize sz = self.bounds.size;
    sz.height = headerHeight + additionalSpace + collectionHeight;
    return sz;
}

@end
