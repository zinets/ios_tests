//
// Created by Zinets Viktor on 12/19/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ViewShapeOneCorner,
    ViewShapeTwoCorners,
    ViewShapeTrapeze,
    ViewShapeX,
    ViewShapeShield,
    ViewShapeCuttedCorner,
} ViewShapeType;

@interface ViewShape : NSObject
+(void)applyShape:(ViewShapeType)shape toView:(UIView *)view;
@end