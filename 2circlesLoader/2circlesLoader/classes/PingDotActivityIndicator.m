//
// Created by Victor Zinets on 7/11/18.
// Copyright (c) 2018 Dolboyob Inc. All rights reserved.
//

#import "PingDotActivityIndicator.h"

@interface PingDotActivityIndicator()
@property (nonatomic) CGFloat dotDiameter;
@property (nonatomic) NSInteger numOfDots;

@property (nonatomic, strong) UIColor *dotColor;

@property (nonatomic, strong) CAReplicatorLayer *replicator;
@property (nonatomic, strong) CAShapeLayer *dot;
@end

@implementation PingDotActivityIndicator {

}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor brownColor];
    self.dotColor = [UIColor whiteColor];

    self.dotDiameter = 15;
    self.numOfDots = 3;
}

#pragma mark getters -

-(CAReplicatorLayer *)replicator {
    if (!_replicator) {
        _replicator = [CAReplicatorLayer layer];

        _replicator.frame = self.layer.bounds;
        _replicator.instanceCount = self.numOfDots;
        _replicator.instanceDelay = .5;
        CGFloat angle = (2.0 * M_PI) / self.replicator.instanceCount;
        _replicator.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);

    }
    return _replicator;
}

-(CALayer *)dot {
    if (!_dot) {
        _dot = [CAShapeLayer layer];
        _dot.backgroundColor = [UIColor clearColor].CGColor;
        _dot.fillColor = self.dotColor.CGColor;

        CGRect frm = (CGRect){0, 0, self.dotDiameter, self.dotDiameter};
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:frm];

        _dot.path = path.CGPath;
    }
    return _dot;
}

#pragma mark public -

- (void)startAnimation {
    [self.layer addSublayer:self.replicator];
    [self.replicator addSublayer:self.dot];

    [self.replicator removeAllAnimations];
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    CGFloat angle = (2.0 * M_PI) / self.replicator.instanceCount;
    rotation.toValue = @(angle);
    rotation.duration = 1.5 / self.replicator.instanceCount;
    rotation.repeatCount = HUGE_VALF;
    [self.replicator addAnimation:rotation forKey:@"rotatingAnimation"];


    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    CATransform3D transform3D = CATransform3DMakeTranslation(0, 0, 50);
//    transform3D.m34 = 1. / 100.;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.duration = _replicator.instanceDelay;
    pulseAnimation.toValue = @(1.5); //[NSValue valueWithCATransform3D:transform3D]; //@(50);
    pulseAnimation.repeatCount = HUGE_VAL;
    [self.dot addAnimation:pulseAnimation forKey:@"1"];
}

- (void)stopAnimation {

}

@end