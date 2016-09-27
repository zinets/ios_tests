//
//  PhotosGalleryView.m
//  Flirt
//
//  Created by Eugene Zhuk on 7/18/16.
//  Copyright © 2016 Yarra. All rights reserved.
//

#import "PhotosGalleryView.h"
#import "PhotoScrollerView.h"
#import "CaptureSessionManager.h"
#import "PhotoGalleryAssetsManager.h"
#import "UIView+Geometry.h"

@interface PhotosGalleryView () <PhotoScrollerDataSource, PhotoScrollerDelegate> {
    PhotoScrollerView * _photoScroll;
    CaptureSessionManager *_cameraManager;
    UIImageView *_cameraView;
}
@property (nonatomic, strong) NSMutableArray *assets;
@end

@implementation PhotosGalleryView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _photoScroll = [[PhotoScrollerView alloc] initWithFrame:self.bounds];
        _photoScroll.clipsToBounds = NO;
        _photoScroll.pagingEnabled = NO;
        _photoScroll.dataSource = self;
        _photoScroll.photoScrollerDelegate = self;
        [self addSubview:_photoScroll];
        [self getCameraRollImages];
    }
    return self;
}

- (void)getCameraRollImages {
    self.assets = [NSMutableArray new];
    [PhotoGalleryAssetsManager getPhotosWitCompletion:^(NSArray<AssetPhotoObject *> *photos) {
        [self.assets addObjectsFromArray:photos];
        [_photoScroll reloadPhotos];
    }];
}

- (void)setCameraSessionStarted:(BOOL)start {
    if (start) {
        [_cameraManager startSession];
    } else {
        [_cameraManager stopSession];
    }
}

#pragma mark - PhotoScrollerViewProto
- (NSInteger)numberOfPhotos {
    return self.assets.count + 1;
}

- (UIView *)scroller:(PhotoScrollerView *)scroller viewForIndex:(NSInteger)index {
    if (index == 0) {
        if (!_cameraView) {
            _cameraView = [[UIImageView alloc] init];
            _cameraView.backgroundColor = [UIColor blackColor];
            UIImageView *overlay = [[UIImageView alloc] initWithFrame:_cameraView.bounds];
            overlay.image = [UIImage imageNamed:@"action-sheet-photo"];
            overlay.contentMode = UIViewContentModeCenter;
            overlay.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.10f];
            overlay.autoresizingMask = UIViewAutoresizingFlexibleSize;
            [_cameraView addSubview:overlay];
        }
#ifndef TARGET_OS_SIMULATOR
        if (!_cameraManager) {
            _cameraManager = [[CaptureSessionManager alloc] init];
            _cameraManager.imageOutputView = _cameraView;
        }
#else
        _cameraView.backgroundColor = [UIColor redColor];
        return _cameraView;
#endif
    } else {
        UIImageView *iv = (id)[scroller dequeueView];
        if (_cameraView && iv == _cameraView) {
            iv = (id)[scroller dequeueView];
        }
        if (iv == nil) {
            iv = [[UIImageView alloc] initWithFrame:(CGRect){{0, 0}, {_photoScroll.height, _photoScroll.height}}];
            iv.contentMode = UIViewContentModeScaleAspectFill;
            iv.clipsToBounds = YES;
        }
        AssetPhotoObject *object = self.assets[index - 1];
        iv.image = object.thumbnail;
        return iv;
    }
}

- (CGFloat)spaceBetweenViews:(PhotoScrollerView *)sender {
    return 4;
}

- (void)scroller:(PhotoScrollerView *)scroller didSelectPhoto:(NSInteger)index {
    if (index == 0) {
        if ([_delegate respondsToSelector:@selector(photosGalleryViewCameraClicked:)]) {
            [_delegate photosGalleryViewCameraClicked:self];
        }
    } else {
        if ([_delegate respondsToSelector:@selector(photosGalleryView:imageSelected:)]) {
            AssetPhotoObject *object = self.assets[index - 1];
            [_delegate photosGalleryView:self imageSelected:object.fullsize];
        }
    }
}

- (CGSize)scroller:(PhotoScrollerView *)scroller sizeForViewWithIndex:(NSInteger)index {
    return (CGSize){88, 88};
}
@end
