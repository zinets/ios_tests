//
// Created by Zinets Viktor on 9/28/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PixelateLayer.h"

@implementation PixelateLayer {

}

- (instancetype)init:(ShapeType)shape resolution:(CGFloat)resolution size:(CGFloat)size offset:(CGFloat)offset alpha:(CGFloat)alpha {
    if (self = [super init]) {
        _shape = shape;
        _resolution = resolution;
        _size = size;
        _offset = offset;
        _alpha = alpha;
    }
    return self;
}

@end