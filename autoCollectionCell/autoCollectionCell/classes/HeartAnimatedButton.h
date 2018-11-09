//
// Created by Zinets Viktor on 9/29/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SITE_ID
#warning TESTING MODE!!!
#define ColorButton UIButton
#endif

// контроль для анимированного показа нажатия; обычным способом назначаем картинки, минимум нужно указать 3 состояния (normal, hlighted, selected), хайлайтед и селектед используется для анимации
@interface HeartAnimatedButton : ColorButton
/// максимальная высота, на которую поднимется сердечко
@property (nonatomic) CGFloat maxHeightOfRaising;
/// добавить анимацию; может начинаться как по тапу, так и в произвольный момент; внешняя анимация использует только highl ресурс, а своя - selected
- (void)addAnimation;
@end