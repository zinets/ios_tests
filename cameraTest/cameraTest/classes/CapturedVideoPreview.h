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
// этот класс добавился не очень запланировано, так что кривовато; playControl это ссылка на где-то сдизайненую кнопку play/pause которую надо в определенных случаях а) раздизаблить (когда видео будет готово к просмотру) и б) убрать .selected если видео доигралось до конца (визуально кнопка реагирует на selected == играется)
@property (nonatomic, weak) UIButton *playControl;
@property (nonatomic, readonly) NSURL *videoUrl;
- (void)play;
- (void)pause;
@end
