//
//  FavButton.h
//  testAnimationMaskEmmiters
//
//  Created by Victor Zinets on 5/21/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ColorButton.h"

/* очень кастомная кнопка:
 1) нажимаем кнопку, картинка меняется (берется картинка для hlited)
 2) начинается анимация: картинка для hlited режима летит в ебеня по координатам, указанным в методе как destPoint
    анимация - просто пролет из точки (центр кнопки) в точку (destPoint) по дуге, с кручением и увеличением/уменьшением
 3) после попадания начинается анимация lotti (если есть)
 4) после окончания анимации (или сразу, если ее нет) начинается анимация: selected состояние кнопки анимируется в финальное положение
*/
@interface LottieAnimatedButton : ColorButton
- (void)setSelectedUsingAnimation:(void (^)(void))lottieAnimation atFinishPoint:(CGPoint)destPoint;
@end
