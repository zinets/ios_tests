//
//  FavButton.h
//  testAnimationMaskEmmiters
//
//  Created by Victor Zinets on 5/21/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ColorButton.h"

@interface LottieAnimatedButton : ColorButton
- (void)performPreSelectAnimation:(CGPoint)destPoint lottieAnimation:(void (^)(void))block;
@end
