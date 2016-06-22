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
        CGRect frame = (CGRect){{pt.x - self.diameter / 2, pt.y - self.diameter / 2}, {self.diameter, self.diameter}};
        _dot.cornerRadius = self.diameter / 2.;
        _dot.frame = frame;
        _dot.backgroundColor = [UIColor whiteColor].CGColor;
    }
    return _dot;
}

#pragma mark - state

- (void)setStage:(AnimationStage)stage {
    CGPoint pt = center(self.layer.bounds);
    switch (stage) {
        case AnimationStageStart: {
            CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"position.x"];
            transform.toValue = @(pt.x - self.diameter / 2 - self.radius);
            transform.duration = 0.1;
            transform.repeatCount = 0;
            transform.autoreverses = NO;
            transform.removedOnCompletion = NO;
            transform.fillMode = kCAFillModeBoth;
            [self.dot removeAnimationForKey:@"posX"];
            [self.dot addAnimation:transform forKey:@"posX"];
            
            CGFloat angle = (2.0 * M_PI) / self.replicator.instanceCount;
            self.replicator.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
            [self.layer addSublayer:self.replicator];
            [self.replicator addSublayer:self.dot];
            
            [self.replicator removeAllAnimations];
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotation.toValue = @(-2.0 * M_PI);
            rotation.duration = 1.2;
            rotation.repeatCount = 1000;
            [_replicator addAnimation:rotation forKey:@"rotatingAnimation"];

        } break;
        case AnimationStageCollapsing: {
            CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"position.x"];
            transform.fromValue = @(pt.x - self.diameter / 2 - self.radius);
            transform.toValue = @(pt.x - self.diameter / 2);
            transform.duration = 0.1;
            transform.repeatCount = 0;
            transform.autoreverses = NO;
            transform.removedOnCompletion = NO;
            transform.fillMode = kCAFillModeBackwards;
//            transform.delegate = self;

            [self.dot addAnimation:transform forKey:@"posX"];
        } break;
        case AnimationStage2: {
            CGFloat angle = (2.0 * M_PI) / self.replicator.instanceCount;
            
            self.replicator.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
            
            [self.layer addSublayer:self.replicator];
            [self.replicator addSublayer:self.dot];
            
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotation.toValue = @(-2.0 * M_PI);
            rotation.duration = 1.2;
            rotation.repeatCount = 1000;
            //    rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            [_replicator addAnimation:rotation forKey:@"replicatedAnimation"];

        } break;
        case AnimationStage3: {
//            CALayer *dot = [CALayer layer];
//            
//            CGRect frame = (CGRect){{0, 0}, {diameter, diameter}};
//            dot.cornerRadius = diameter / 2.;
//            dot.frame = frame;
//            dot.backgroundColor = [UIColor whiteColor].CGColor;
//            
//            [self.layer addSublayer:dot];
//            
//            CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"position.x"];
//            transform.toValue = @(100);
//            transform.duration = 0.2;
//            transform.repeatCount = 0;
//            transform.autoreverses = NO;
//            transform.removedOnCompletion = NO;
//            transform.fillMode = kCAFillModeForwards;
//
//            [dot addAnimation:transform forKey:@"posX"];
        } break;
        default:
            break;
    }
    

}

@end
