//
//  FiveStarsActivityIndicator.m
//  testCustomActivityIndicator
//
//  Created by Zinets Victor on 6/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "FiveStarsActivityIndicator.h"


@interface FiveStarsActivityIndicator() {

}
@property (nonatomic, strong) CAReplicatorLayer *replicator;
@property (nonatomic, strong) CALayer *dot;
@property (nonatomic, strong) CAShapeLayer *leftMarkPart;
@property (nonatomic, strong) CAShapeLayer *rightMarkPart;

@property (nonatomic) CGFloat diameter;
@property (nonatomic) CGFloat radius;
@property (nonatomic) NSInteger numOfDots;
@end

CGPoint center(CGRect rect) {
    return (CGPoint){rect.size.width / 2, rect.size.height / 2};
}

CGPoint CGPointOffset (CGPoint origin, int x, int y) {
    origin.x += x;
    origin.y += y;
    
    return origin;
}

@implementation FiveStarsActivityIndicator


- (void)setup {
    self.backgroundColor = [UIColor lightGrayColor];
    self.diameter = 14;
    self.radius = 55/2;
    self.numOfDots = 5;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

#pragma mark - getters

-(CAReplicatorLayer *)replicator {
    if (!_replicator) {
        _replicator = [CAReplicatorLayer layer];
        
        _replicator.frame = self.layer.bounds;
        _replicator.instanceCount = self.numOfDots;
        _replicator.instanceDelay = 0.1;
    }
    return _replicator;
}

-(CALayer *)dot {
    if (!_dot) {
        CGPoint pt = center(self.layer.bounds);
        
        _dot = [CALayer layer];
        CGRect frame = (CGRect){{pt.x - self.diameter / 2 - self.radius, pt.y - self.diameter / 2}, {self.diameter, self.diameter}};
        _dot.cornerRadius = self.diameter / 2.;
        _dot.frame = frame;
        _dot.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _dot;
}

-(CAShapeLayer *)leftMarkPart {
    if (!_leftMarkPart) {
        CGPoint pt = center(self.layer.bounds);
        
        _leftMarkPart = [CAShapeLayer layer];
        _leftMarkPart.frame = self.layer.bounds;
        _leftMarkPart.lineCap = kCALineCapRound;
        _leftMarkPart.strokeColor = [UIColor whiteColor].CGColor;
        _leftMarkPart.lineWidth = self.diameter;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:pt];
        pt = CGPointOffset(pt, -18, -18);
        [path addLineToPoint:pt];
        
        _leftMarkPart.path = path.CGPath;
    }
    return _leftMarkPart;
}

-(CAShapeLayer *)rightMarkPart {
    if (!_rightMarkPart) {
        CGPoint pt = center(self.layer.bounds);
        
        _rightMarkPart = [CAShapeLayer layer];
        _rightMarkPart.frame = self.layer.bounds;
        _rightMarkPart.lineCap = kCALineCapRound;
        _rightMarkPart.strokeColor = [UIColor whiteColor].CGColor;
        _rightMarkPart.lineWidth = self.diameter;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:pt];
        pt = CGPointOffset(pt, -36, -36);
        [path addLineToPoint:pt];
        
        _rightMarkPart.path = path.CGPath;
    }
    return _rightMarkPart;
}

#pragma mark - state

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self setStage:(AnimationStageFinishing)];
    }
}

- (void)setStage:(AnimationStage)stage {
    CGPoint pt = center(self.layer.bounds);
    switch (stage) {
        case AnimationStageStart: {
            CGFloat angle = (2.0 * M_PI) / self.replicator.instanceCount;
            self.replicator.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
            [self.layer addSublayer:self.replicator];
            [self.replicator addSublayer:self.dot];
            
            [self.replicator removeAllAnimations];
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotation.toValue = @(2.0 * M_PI);
            rotation.duration = 1.2;
            rotation.repeatCount = HUGE_VALF;
            [self.replicator addAnimation:rotation forKey:@"rotatingAnimation"];
        } break;
        case AnimationStageFinishing: {
            [self.layer addSublayer:self.leftMarkPart];
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = [NSNumber numberWithFloat:0.0];
            animation.toValue = [NSNumber numberWithFloat:1.0];
            animation.duration = 0.2;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            [self.leftMarkPart addAnimation:animation forKey:@"leftPartAnimation"];
            
            [self.layer addSublayer:self.rightMarkPart];
            CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
            groupAnimation.duration = 0.4; {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
                animation.fromValue = [NSNumber numberWithFloat:0.0];
                animation.toValue = [NSNumber numberWithFloat:1.0];
                animation.duration = 0.2;
                animation.removedOnCompletion = NO;
                animation.fillMode = kCAFillModeForwards;
                
                CABasicAnimation *rotating = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
                rotating.toValue = @(M_PI_2);
                rotating.duration = .2;
                rotating.beginTime = .2;
                rotating.removedOnCompletion = NO;
                rotating.fillMode = kCAFillModeForwards;
                
                groupAnimation.animations = @[animation, rotating];
            }
            groupAnimation.removedOnCompletion = NO;
            groupAnimation.fillMode = kCAFillModeForwards;
            
            [self.rightMarkPart addAnimation:groupAnimation forKey:@"rightPartAnimation"];
            
            [_replicator removeAllAnimations];
            [_replicator removeFromSuperlayer];
            _replicator = nil;
            
            
        } break;
    }
}

@end
