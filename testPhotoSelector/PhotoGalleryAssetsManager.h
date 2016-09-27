//
//  PhotoGalleryAssetsManager.h
//  Flirt
//
//  Created by Eugene Zhuk on 7/19/16.
//  Copyright © 2016 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetPhotoObject : NSObject
@property (nonatomic, readonly) UIImage *thumbnail;
@property (nonatomic, readonly) UIImage *fullsize;
@end

@interface PhotoGalleryAssetsManager : NSObject
+ (void)getPhotosWitCompletion:(void (^)(NSArray <AssetPhotoObject *> *photos))completion;
+ (void)checkAuthorizationStatusWithCompletion:(void(^)(BOOL granted))completion;
+ (void)checkCameraAuthorizationStatusWithCompletion:(void(^)(BOOL granted))completion;
@end
