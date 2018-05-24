//
//  GrayscaleImageView.h
//
//  Created by Victor Zinets on 5/24/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

@import TNURLImageView;

typedef enum {
    BWChangeStyleFade,
    // todo: rename me! убирание ч/б расширением дырки из точки на весь фрейм
    BWChangeStyleScale,
} BWChangeStyle;

@interface GrayscaleImageView : TNImageView
/// отсюда начнет проявляться цветная версия; по умолчанию центр контрола
@property (nonatomic) CGPoint startAnimationPoint;
/// ч/б режим?
@property (nonatomic) BOOL bwMode;
/// как проявляется цветная картинка
@property (nonatomic) BWChangeStyle bwChangingStyle;
@end
