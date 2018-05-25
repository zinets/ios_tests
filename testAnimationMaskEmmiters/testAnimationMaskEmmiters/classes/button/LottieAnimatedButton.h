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

/// время полета шмеля до начала "настоящей" анимации
@property (nonatomic) NSTimeInterval animationDuration;
/// пункт назначения для hlited иконки (которая при селекте летит в ибеня)
@property (nonatomic) CGPoint destPoint;
/// блок, который заработает после прибытия в пункт назначения
@property (nonatomic, copy) void (^destinationAnimationBlock)(void);
/// делать selected "как обычно" или с анимацией
@property (nonatomic) BOOL animatedSelection;

@end
