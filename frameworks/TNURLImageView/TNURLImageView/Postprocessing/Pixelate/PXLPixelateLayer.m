//
// Created by Zinets Viktor on 9/28/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PXLPixelateLayer.h"

@implementation PXLPixelateLayer

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

+ (instancetype)layerWithShape:(ShapeType)shape resolution:(CGFloat)resolution size:(CGFloat)size offset:(CGFloat)offset alpha:(CGFloat)alpha {
    return [[self alloc] init:shape resolution:resolution size:size offset:offset alpha:alpha];
}

+ (instancetype)layerWithShape:(ShapeType)shape size:(CGFloat)size {
    return [[self alloc] init:shape resolution:size size:size offset:0 alpha:1];
}

@end
