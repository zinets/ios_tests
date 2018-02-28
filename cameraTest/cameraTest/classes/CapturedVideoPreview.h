//
//  CapturedVideoPreview.h
//  cameraTest
//
//  Created by Zinets Victor on 2/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CapturedVideoPreview : UIView
+ (instancetype)videoPreviewWithUrl:(NSURL *)videoUrl;
@property (nonatomic, weak) UIButton *playControl;
- (void)play;
- (void)pause;
@end
