//
// Created by Zinets Viktor on 9/28/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIkit/UIKit.h>
#import "PixelateLayer.h"

@interface Pixelator : NSObject
+ (UIImage *)create:(UIImage *)image layers:(NSArray <PixelateLayer *> *)layers;
@end