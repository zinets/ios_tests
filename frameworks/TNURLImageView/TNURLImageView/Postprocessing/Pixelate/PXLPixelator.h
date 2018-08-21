//
// Created by Zinets Viktor on 9/28/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIkit/UIKit.h>
#import "PXLPixelateLayer.h"

@interface PXLPixelator : NSObject
+ (UIImage *)create:(UIImage *)image layers:(NSArray <PXLPixelateLayer *> *)layers;
@end
