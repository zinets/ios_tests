//
//  TNImageView.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TNImageTypes.h"


@interface TNImageView : UIImageView

#pragma mark - callbacks
@property (nonatomic, copy) UIImage * _Nullable (^ _Nullable onImageLoaded)(UIImage * _Nullable img);
@property (nonatomic, copy) void(^ _Nullable onLoadCompleted)(CGSize imageSize);
@property (nonatomic, copy) void(^ _Nullable onLoadError)(void);

#pragma mark views
@property (nonatomic, strong) UIView * _Nullable placeholderView;
@property (nonatomic, strong) UIView * _Nullable loadingView;
@property (nonatomic, strong) UIView * _Nullable overlayView;

#pragma mark progress
@property (nonatomic, assign) BOOL allowLoadingAnimation;
@property (nonatomic, assign) CGFloat loadingAnimationDuration;

#pragma mark utility methods
@property (nonatomic, assign) CGSize resizeImageToSize;
@property (nonatomic, assign) BOOL hasToClearImage;
@property (nonatomic, readonly, nullable) NSString *currentImageURLString;

#pragma mark animated contentMode
@property (nonatomic) NSTimeInterval contentModeAnimationDuration;

#pragma mark load/cancel
- (void)loadImageFromUrl:(NSString *_Nullable)url;
- (void)loadImageFromUrl:(NSString *_Nullable)url withType:(ImageType)type;
- (void)loadImageFromUrl:(NSString *_Nullable)url forceLoad:(BOOL)forceLoad;
- (void)loadImageFromUrl:(NSString *_Nullable)url withType:(ImageType)type forceLoad:(BOOL)forceLoad;
- (void)cancelLoading;

/// вернет YES, если в кеше есть картинка для этого урла
- (BOOL)haveImageForUrl:(NSString *_Nullable)url;

+ (void)preloadImages:(NSArray <NSString *> *_Nullable)urlList;
+ (void)preloadImages:(NSArray <NSString *> *_Nullable)urlList withType:(ImageType)type;

- (void)getImageWithType:(ImageType)type onImageLoaded:(void (^_Nullable)(UIImage *_Nullable))onImageLoaded;

@end
