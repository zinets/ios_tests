//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "ShadowControl.h"

@interface ShadowControl ()
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation ShadowControl {
    CALayer *shadowLayer;

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        shadowLayer = [CALayer layer];
        shadowLayer.frame = self.bounds;
        shadowLayer.mask = self.maskLayer;

        [self.layer addSublayer:shadowLayer];

        self.userInteractionEnabled = YES;
    }

    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    shadowLayer.backgroundColor = backgroundColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    shadowLayer.frame = self.bounds;
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
    }
    return _maskLayer;
}

- (void)setFrameToUnmask:(CGRect)frameToUnmask {
    _frameToUnmask = frameToUnmask;

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *hole = [UIBezierPath bezierPathWithRect:_frameToUnmask];
    [path appendPath:hole];
    [path setUsesEvenOddFillRule:YES];

    self.maskLayer.path = path.CGPath;
}

@end