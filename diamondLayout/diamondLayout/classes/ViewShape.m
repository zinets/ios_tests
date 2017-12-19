//
// Created by Zinets Viktor on 12/19/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "ViewShape.h"


@implementation ViewShape {

}

+ (CAShapeLayer *)shapeForRandomCornerMask:(CGRect)frame {
    CAShapeLayer *shape = [CAShapeLayer layer];
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    shape.frame = (CGRect){0, 0, w, h};

    CGFloat const radii = MAX(70, w / 2 - 20);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPoint){0, 0}];
    [path addLineToPoint:(CGPoint){w - radii, 0}];
    [path addArcWithCenter:(CGPoint){w - radii, radii} radius:radii startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:(CGPoint){w, h}];
    [path addLineToPoint:(CGPoint){0, h}];

    [path closePath];

    shape.path = path.CGPath;
    shape.anchorPoint = (CGPoint){0.5, 0.5};
    shape.affineTransform = CGAffineTransformMakeRotation(M_PI_2 * arc4random_uniform(4));
    return shape;
}

+ (CAShapeLayer *)shapeForRandomCutMask:(CGRect)frame {
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    shape.frame = (CGRect){0, 0, w, h};

    CGFloat w1 = MAX(30, arc4random_uniform(w / 2) - 20);
    CGFloat h1 = h - w1;

    [path moveToPoint:(CGPoint){w1, 0}];
    [path addLineToPoint:(CGPoint){w, 0}];
    [path addLineToPoint:(CGPoint){w, h}];
    [path addLineToPoint:(CGPoint){0, h}];
    [path addLineToPoint:(CGPoint){0, h1}];

    [path closePath];
    shape.path = path.CGPath;
    shape.anchorPoint = (CGPoint){0.5, 0.5};
    shape.affineTransform = CGAffineTransformMakeRotation(M_PI_2 * arc4random_uniform(4));
    return shape;
}

+ (CAShapeLayer *)shapeForTwoCornerMask:(CGRect)frame {
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat const radii = 96;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;

    [path moveToPoint:(CGPoint){0, 0}];
    [path addLineToPoint:(CGPoint){w - radii, 0}];
    [path addArcWithCenter:(CGPoint){w - radii, radii} radius:radii startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    [path addLineToPoint:(CGPoint){w, h}];
    [path addLineToPoint:(CGPoint){radii, h}];
    [path addArcWithCenter:(CGPoint){radii, h - radii} radius:radii startAngle:M_PI_2 endAngle:M_PI clockwise:YES];

    [path closePath];
    shape.path = path.CGPath;
    return shape;
}

+ (CAShapeLayer *)shapeForTrapezeMask:(CGRect)frame {
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat w1 = 32, w2 = 60;
    CGFloat h1 = 110, h2 = 210;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;

    [path moveToPoint:(CGPoint){w1, 0}];
    [path addLineToPoint:(CGPoint){w, 0}];
    [path addLineToPoint:(CGPoint){w, h - h2}];
    [path addLineToPoint:(CGPoint){w - w2, h}];
    [path addLineToPoint:(CGPoint){0, h}];
    [path addLineToPoint:(CGPoint){0, h1}];

    [path closePath];
    shape.path = path.CGPath;
    return shape;
}

+ (CAShapeLayer *)shapeForXMask:(CGRect)frame {
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat d = 50;
    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    CGFloat w2 = frame.size.width / 2;
    CGFloat h2 = frame.size.height / 2;

    [path moveToPoint:(CGPoint){0, 0}];
    [path addLineToPoint:(CGPoint){w2 - d, 0}];
    [path addLineToPoint:(CGPoint){w2, d}];
    [path addLineToPoint:(CGPoint){w2 + d, 0}];
    [path addLineToPoint:(CGPoint){w, 0}];

    [path addLineToPoint:(CGPoint){w, h2 - d}];
    [path addLineToPoint:(CGPoint){w - d, h2}];
    [path addLineToPoint:(CGPoint){w, h2 + d}];
    [path addLineToPoint:(CGPoint){w, h}];

    [path addLineToPoint:(CGPoint){w2 + d, h}];
    [path addLineToPoint:(CGPoint){w2, h - d}];
    [path addLineToPoint:(CGPoint){w2 - d, h}];
    [path addLineToPoint:(CGPoint){0, h}];

    [path addLineToPoint:(CGPoint){0, h2 + d}];
    [path addLineToPoint:(CGPoint){d, h2}];
    [path addLineToPoint:(CGPoint){0, h2 - d}];


    [path closePath];
    shape.path = path.CGPath;
    return shape;
}

+ (CAShapeLayer *)shapeForShieldMask:(CGRect)frame {
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];

    CGFloat w = frame.size.width;
    CGFloat h = frame.size.height;
    CGFloat h1 = 60;


    [path moveToPoint:(CGPoint){0, 0}];
    [path addLineToPoint:(CGPoint){w, 0}];
    [path addLineToPoint:(CGPoint){w, h - h1}];
    [path addLineToPoint:(CGPoint){w / 2, h}];
    [path addLineToPoint:(CGPoint){0, h - h1}];

    [path closePath];
    shape.path = path.CGPath;
    return shape;
}

+(void)applyShape:(ViewShapeType)shape toView:(UIView *)view {
    switch (shape) {
        case ViewShapeTwoCorners:
            view.layer.mask = [self shapeForTwoCornerMask:view.bounds];
            break;
        case ViewShapeTrapeze:
            view.layer.mask = [self shapeForTrapezeMask:view.bounds];
            break;
        case ViewShapeX:
            view.layer.mask = [self shapeForXMask:view.bounds];
            break;
        case ViewShapeShield:
            view.layer.mask = [self shapeForShieldMask:view.bounds];
            break;
        case ViewShapeOneCorner:
            view.layer.mask = [self shapeForRandomCornerMask:view.bounds];
            break;
        case ViewShapeCuttedCorner:
            view.layer.mask = [self shapeForRandomCutMask:view.bounds];
            break;
    }
    view.layer.masksToBounds = YES;
}

@end
