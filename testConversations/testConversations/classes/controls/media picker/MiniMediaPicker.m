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
#import "MiniMediaPickerEmptyView.h"

@interface MiniMediaPicker() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> {
    PHFetchResult <PHAsset *> *fetchedAlbumItems;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UIView *restrictPlaceholder;
@property (nonatomic, strong) UIView *emptyPlaceholder;

@property (nonatomic) PHAuthorizationStatus authStatus;
@property (nonatomic, strong) PHImageManager *imageManager;
@end

@implementation MiniMediaPicker

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self addSubview:self.moreButton];
        
        self.authStatus = [PHPhotoLibrary authorizationStatus];
        if (self.authStatus == PHAuthorizationStatusAuthorized) {
            [self updateDatasource];
        } else {
            [self addSubview:self.restrictPlaceholder];
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self.restrictPlaceholder removeFromSuperview];
                    self.authStatus = status;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateDatasource];
                    });
                }
            }];
        }
        
        self.imageManager = [PHImageManager defaultManager];
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

-(UIView *)emptyPlaceholder {
    if (!_emptyPlaceholder) {
        _emptyPlaceholder = [[MiniMediaPickerEmptyView alloc] initWithFrame:self.bounds];
        _emptyPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _emptyPlaceholder;
}

#pragma mark collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = fetchedAlbumItems.count;
    
    self.moreButton.hidden = count == 0;
    return count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MediaPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell.tag) {
        [self.imageManager cancelImageRequest:(PHImageRequestID)cell.tag];
    }
    
    cell.tag = [self.imageManager requestImageForAsset:fetchedAlbumItems[indexPath.item]
                                            targetSize:[self itemSize]
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil
                                         resultHandler:^(UIImage *result, NSDictionary *info) {
                                             if (![info[PHImageResultIsDegradedKey] boolValue]) {
                                                 MediaPickerCell *c = (MediaPickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
                                                 if (c) {
                                                     [c setImage:result];
                                                 } else {
                                                     [cell setImage:result];
                                                 }
                                             }
    }];
    
    return cell;
}

- (CGSize)itemSize {
    CGFloat w = floor((self.collectionView.bounds.size.width - 2) / 2);
    CGFloat h = w * 1.25; // я так вижу.. из диза
    return (CGSize){w, h};
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self itemSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(miniMediaPicker:didSelectAsset:)]) {
        PHAsset *asset = fetchedAlbumItems[indexPath.item];
        [self.delegate miniMediaPicker:self didSelectAsset:asset];
//        switch (asset.mediaType) {
//            case PHAssetMediaTypeImage: {
//                PHImageRequestOptions *options = [PHImageRequestOptions new];
//                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//                options.resizeMode = PHImageRequestOptionsResizeModeExact;
//
//                CGFloat w = asset.pixelWidth;
//                CGFloat h = asset.pixelHeight;
//                CGFloat const maxVal = 1000; // какой макс. размер картинки для педерачи?
//                //  вообще как показывает тестирование - почти до лампочки; возвращается полный размер; ну или если очень сильно отличается заказаный ([0; 0] к примеру) - возвращается картинка крохотного размера
//                // короче код для подстраховки
//                CGFloat ar = w > h ? (w / maxVal) : (h / maxVal);
//                if (ar > 1) {
//                    w /= ar;
//                    h /= ar;
//                }
//                [self.imageManager requestImageForAsset:asset
//                                             targetSize:(CGSize){w, h}
//                                            contentMode:PHImageContentModeAspectFill
//                                                options:nil
//                                          resultHandler:^(UIImage *result, NSDictionary *info) {
//                                              if (![info[PHImageResultIsDegradedKey] boolValue]) {
//                                                  [self.delegate miniMediaPicker:self didSelectImage:result];
//                                              }
//                                          }];
//            } break;
//            case PHAssetMediaTypeVideo: {
//                PHVideoRequestOptions *options = [PHVideoRequestOptions new];
//                options.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
//                // todo не надо ли включить тут какой-то индикатор занятости?
//                [self.imageManager requestExportSessionForVideo:asset
//                                                        options:options
//                                                   exportPreset:AVAssetExportPresetAppleM4VCellular
//                                                  resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info)
//                 {
//                     // temp file for storing
//                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                     NSString *documentsDirectory = [paths objectAtIndex:0];
//                     NSString *videoPath = [documentsDirectory stringByAppendingPathComponent:@"temp.mp4"];
//
//                     NSFileManager *manager = [NSFileManager defaultManager];
//                     NSError *error = nil;
//                     if ([manager fileExistsAtPath:videoPath]) {
//                         BOOL success = [manager removeItemAtPath:videoPath error:&error];
//                         if (success) {
//                             NSLog(@"Removed existing temp video!");
//                         } else {
//                             NSLog(@"Error %@", error);
//                         }
//                     }
//
//                     exportSession.outputURL = [NSURL fileURLWithPath:videoPath];
//                     exportSession.outputFileType = AVFileTypeAppleM4V;
//                     exportSession.shouldOptimizeForNetworkUse = YES;
//
//                     [exportSession exportAsynchronouslyWithCompletionHandler:^{
//
//                     }];
//                 }];
//            } break;
//            default:
//                break;
//        }
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
                    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d || mediaType == %d", PHAssetMediaTypeImage, PHAssetMediaTypeVideo];
                    fetchedAlbumItems = [PHAsset fetchAssetsInAssetCollection:collection options:options];
                }];

                [self.collectionView reloadData];
            } break;
            default: // если было запрещено - то так и осталось; а значит и делать ничего не буду
                break;
        }
    
}

@end
