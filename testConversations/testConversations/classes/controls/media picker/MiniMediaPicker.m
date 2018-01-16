//
//  MiniMediaPicker.m
//  testConversations
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "MiniMediaPicker.h"

#import "MediaPickerCell.h"
#import "MiniMediaPickerRestrictedView.h"

@interface MiniMediaPicker() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> {
    PHFetchResult <PHAsset *> *fetchedAlbumItems;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *restrictPlaceholder;

@property (nonatomic) PHAuthorizationStatus authStatus;
@end

@implementation MiniMediaPicker

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            self.authStatus = status;
        }];
        
        [self addSubview:self.collectionView];
        [self addSubview:self.moreButton];
        
        [self updateDatasource];
    }
    return self;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *l = [UICollectionViewFlowLayout new];
        l.minimumLineSpacing = l.minimumInteritemSpacing = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:l];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[MediaPickerCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

-(UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _moreButton.frame = (CGRect){16, self.bounds.size.height - 16 - 40, 40, 40};
        _moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
        _moreButton.layer.cornerRadius = 20;
        _moreButton.backgroundColor = [UIColor purpleColor];
        // todo design
        [_moreButton addTarget:self action:@selector(onMoreButtonTap:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _moreButton;
}

- (void)onMoreButtonTap:(id)sender{
    if ([self.delegate respondsToSelector:@selector(miniMediaPickerWantsShowFullLibrary:)]) {
        [self.delegate miniMediaPickerWantsShowFullLibrary:self];
    }
}

-(UIView *)restrictPlaceholder {
    if (!_restrictPlaceholder) {
        _restrictPlaceholder = [[MiniMediaPickerRestrictedView alloc] initWithFrame:self.bounds];
        _restrictPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _restrictPlaceholder;
}

#pragma mark collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = fetchedAlbumItems.count;
    
    self.moreButton.hidden = count == 0;
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = floor((collectionView.bounds.size.width - 2) / 2);
    CGFloat h = w * 1.25; // я так вижу.. из диза
    return (CGSize){w, h};
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(miniMediaPicker:didSelectImage:)]) {
        [self.delegate miniMediaPicker:self didSelectImage:[UIImage imageNamed:@"tolka.jpg"]];
    }
}

#pragma mark datasorce

- (void)updateDatasource {
        switch (self.authStatus) {
            case PHAuthorizationStatusAuthorized: {
                PHFetchResult *res = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                              subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                              options:nil];
                [res enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
                    PHFetchOptions *options = [PHFetchOptions new];
                    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
                    fetchedAlbumItems = [PHAsset fetchAssetsInAssetCollection:collection options:options];
                }];

            } break;
            default: {
                [self addSubview:self.restrictPlaceholder];
            } break;
        }
    
}

@end
