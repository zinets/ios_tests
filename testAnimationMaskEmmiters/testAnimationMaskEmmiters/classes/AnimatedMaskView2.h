//
// Created by Victor Zinets on 5/18/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BWChangeStyleFade,
    // todo: rename me!
    BWChangeStyleScale,
} BWChangeStyle;

@interface AnimatedMaskView2 : UIImageView
/// ч/б режим?
@property (nonatomic) BOOL bwMode;
/// как проявляется цветная картинка
@property (nonatomic) BWChangeStyle bwChangingStyle;
/// отсюда начнет проявляться цветная версия; по умолчанию центр контрола
@property (nonatomic) CGPoint startAnimationPoint;
@end