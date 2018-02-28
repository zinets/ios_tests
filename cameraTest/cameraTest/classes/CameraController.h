//
//  CameraController.h
//  cameraTest
//
//  Created by Victor Zinets on 2/27/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraControllerDelegate <NSObject>
- (void)cameraController:(id)sender tookPhoto:(UIImage *)image;
- (void)cameraController:(id)sender tookVideo:(NSURL *)fileUrl;
@end

@interface CameraController : UIViewController
// photo/video mode
@property (nonatomic) BOOL isVideoMode; // инача photo
@property (nonatomic, weak) id <CameraControllerDelegate> delegate;
@end
