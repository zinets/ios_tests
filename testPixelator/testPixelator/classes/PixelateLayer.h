//
// Created by Zinets Viktor on 9/28/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ShapeCircle,
    ShapeDiamond,
    ShapeSquare,
} ShapeType;

@interface PixelateLayer : NSObject
@property (nonatomic, readonly) ShapeType shape;
@property (nonatomic, readonly) CGFloat resolution;
@property (nonatomic, readonly) CGFloat size;
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) CGFloat offset;
- (instancetype)init:(ShapeType)shape resolution:(CGFloat)resolution size:(CGFloat)size offset:(CGFloat)offset alpha:(CGFloat)alpha;
@end