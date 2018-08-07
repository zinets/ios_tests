//
// Created by Zinets Viktor on 5/17/17.
// Copyright (c) 2017 iCupid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPreview : UIView
/// видео начнет грузится и играться сразу после вызова loadVideo: - ну или нет
@property (nonatomic) BOOL autostart;
/// видео будет проигрываться по кругу
@property (nonatomic) BOOL loop;
/// флаг обозначает "видео загружать ненадо"
@property (nonatomic) BOOL suppressVideoLoad;

/// вью - если есть - служит фоном для плеера - до момента, когда (если) загрузится фоновая картинка или начнется проигрывание видео
@property (nonatomic, strong) UIView *backgroundView;

- (void)loadVideo:(NSString *)videoUrl preview:(NSString *)previewUrl;
- (void)unloadVideo;

- (void)play;
/// change state of player and return resulting state (paused or not)
- (BOOL)pause;
- (void)stop;

@end
