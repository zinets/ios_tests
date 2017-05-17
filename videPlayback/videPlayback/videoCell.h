//
// Created by Zinets Viktor on 5/16/17.
// Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoCell : UIView
@property (nonatomic) BOOL autostart;
/// вью - если есть - служит фоном для плеера - до момента, когда (если) загрузится фоновая картинка или начнется проигрывание видео
@property (nonatomic, strong) UIView *backgroundView;

- (void)loadVideo:(NSString *)videoUrl preview:(NSString *)previewUrl;
- (void)unloadVideo;

- (void)play;
/// change state of player and return resulting state (paused or not)
- (BOOL)pause;
- (void)stop;

@end