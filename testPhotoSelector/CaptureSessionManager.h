//
//  CaptureSessionManager.h
//  Flirt
//
//  Created by Eugene Zhuk on 28.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVCaptureDevice.h>

@interface CaptureSessionManager : NSObject
@property (nonatomic, strong) UIImageView *imageOutputView;
- (void)startSession;
- (void)stopSession;
- (void)takePhotoWithCompletionHandler:(void (^)(UIImage *image))handler;
- (void)setFlashMode:(AVCaptureFlashMode)mode;
///return flash availability for current camera
- (BOOL)switchCameras;
- (BOOL)flashEnabled;
@end
