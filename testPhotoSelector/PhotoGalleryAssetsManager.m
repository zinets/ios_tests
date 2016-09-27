//
//  PhotoGalleryAssetsManager.m
//  Flirt
//
//  Created by Eugene Zhuk on 7/19/16.
//  Copyright © 2016 Yarra. All rights reserved.
//

#import "PhotoGalleryAssetsManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface AssetPhotoObject ()
@property (nonatomic, strong) id asset;
@property (nonatomic, strong) NSDate *creationDate;
@end

@implementation AssetPhotoObject

- (UIImage *)thumbnail {
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    __block UIImage *img;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:(CGSize){200, 200} contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        img = result;
    }];
    return img;
}

- (UIImage *)fullsize {
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES;
    __block UIImage *img;
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:[[UIScreen mainScreen] bounds].size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        img = result;
    }];
    return img;
}

@end

@implementation PhotoGalleryAssetsManager

+ (void)getPhotosWitCompletion:(void (^)(NSArray <AssetPhotoObject *> *photos))completion {
    [self checkAuthorizationStatusWithCompletion:^(BOOL granted) {
        if (granted) {
            [self _getPhotosWitCompletion:completion];
        }
    }];
}

+ (void)_getPhotosWitCompletion:(void (^)(NSArray <AssetPhotoObject *> *photos))completion {
    NSUInteger fetchLimit = 100;
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    if ([options respondsToSelector:@selector(setFetchLimit:)]) {
        options.fetchLimit = fetchLimit;
    }
    PHFetchResult *ph_assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    [ph_assets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        AssetPhotoObject *object = [AssetPhotoObject new];
        object.asset = asset;
        object.creationDate = asset.creationDate;
        [assets addObject:object];
        if (idx == fetchLimit) {
            *stop = YES;
        }
    }];
    
    if (completion) {
        completion(assets);
    }
}

+ (void)checkAuthorizationStatusWithCompletion:(void(^)(BOOL granted))completion {
    __block void(^mainThreadCompletion)(BOOL granted) = ^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(granted);
            }
        });
    };
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        if (mainThreadCompletion) {
            mainThreadCompletion(YES);
        }
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (mainThreadCompletion) {
                mainThreadCompletion(status == PHAuthorizationStatusAuthorized);
                mainThreadCompletion = nil;
            }
        }];
    } else {
        // TODO: access denied. alert to user
        if (mainThreadCompletion) {
            mainThreadCompletion(NO);
        }
    }
}

+ (void)checkCameraAuthorizationStatusWithCompletion:(void(^)(BOOL granted))completion {
    __block void(^mainThreadCompletion)(BOOL granted) = ^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(granted);
            }
        });
    };
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        if (mainThreadCompletion) {
            mainThreadCompletion(YES);
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (mainThreadCompletion) {
                mainThreadCompletion(granted);
            }
        }];
    } else {
        if (mainThreadCompletion) {
            mainThreadCompletion(NO);
        }
    }
}


@end
