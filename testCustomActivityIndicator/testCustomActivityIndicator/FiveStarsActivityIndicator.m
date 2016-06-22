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
@property (nonatomic, strong) CAShapeLayer *checkMarkPart;

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

-(CAShapeLayer *)checkMarkPart {
    if (!_checkMarkPart) {
        CGPoint pt = center(self.layer.bounds);
        
        _checkMarkPart = [CAShapeLayer layer];
        _checkMarkPart.frame = self.layer.bounds;
        _checkMarkPart.lineCap = kCALineCapRound;
        _checkMarkPart.strokeColor = [UIColor whiteColor].CGColor;
        _checkMarkPart.lineWidth = self.diameter;
        _checkMarkPart.lineJoin = kCALineJoinRound;
        _checkMarkPart.fillRule = kCAFillRuleNonZero;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointOffset(pt, -18, -18)];
        [path addLineToPoint:pt];
        [path addLineToPoint:CGPointOffset(pt, 36, 0)];
        
        _checkMarkPart.path = path.CGPath;
    }
    return _checkMarkPart;
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
            [self.layer addSublayer:self.checkMarkPart];
            
            [_replicator removeAllAnimations];
            [_replicator removeFromSuperlayer];
            _replicator = nil;
            
            
        } break;
    }
}

@end
