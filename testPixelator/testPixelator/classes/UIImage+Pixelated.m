//
// Created by Zinets Viktor on 10/19/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "UIImage+Pixelated.h"

@implementation UIImage (Pixelated)

/*
    некоторые забавные варианты пикселяции
    PixelateLayer *layer1 = [[PixelateLayer alloc] init:ShapeSquare resolution:20 size:20 offset:0 alpha:0.8];
    PixelateLayer *layer2 = [[PixelateLayer alloc] init:ShapeCircle resolution:10 size:10 offset:0 alpha:1];
    PixelateLayer *layer3 = [[PixelateLayer alloc] init:ShapeDiamond resolution:20 size:40 offset:0 alpha:0.8];
    PixelateLayer *layer4 = [[PixelateLayer alloc] init:ShapeDiamond resolution:20 size:20 offset:10 alpha:0.8];
*/

- (UIImage *)pixelated {
    CGFloat f = MIN(self.size.width, self.size.height);
    f /= 6;
    UIImage *resImg = [Pixelator create:self layers:@[
            [PixelateLayer layerWithShape:ShapeSquare size:f],
    ]];
    return resImg;
}



@end