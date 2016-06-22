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

-(CAReplicatorLayer *)replicator {
    if (!_replicator) {
        _replicator = [CAReplicatorLayer layer];
    }
    return _replicator;
}

- (void)setStage:(AnimationStage)stage {
    const CGFloat diameter = 14;
    const CGFloat radius = 55/2;
    CGPoint pt = center(self.layer.bounds);
    
    [self.replicator removeAllAnimations];
    [[self.replicator sublayers] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
    
    switch (stage) {
        case AnimationStage1: {
            CALayer *dot = [CALayer layer];
            
            CGRect frame = (CGRect){{pt.x - diameter / 2, pt.y - diameter / 2}, {diameter, diameter}};
            dot.cornerRadius = diameter / 2.;
            dot.frame = frame;
            dot.backgroundColor = [UIColor whiteColor].CGColor;
            
            CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"position.x"];
            transform.toValue = @(pt.x - diameter / 2 - radius);
            transform.duration = 0.2;
            transform.repeatCount = 0;
            transform.autoreverses = NO;
            [dot addAnimation:transform forKey:@"posX"];

            frame.origin.x = pt.x - diameter / 2 - radius;
            dot.frame = frame;
            
            
            self.replicator.frame = self.layer.bounds;
            self.replicator.instanceCount = 5;
            self.replicator.instanceDelay = 0.2;
            CGFloat angle = (2.0 * M_PI) / self.replicator.instanceCount;

            self.replicator.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
            
            [self.layer addSublayer:self.replicator];
            [self.replicator addSublayer:dot];
            
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotation.toValue = @(-2.0 * M_PI);
            rotation.duration = 1.2;
            rotation.repeatCount = 1000;
            //    rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//            [_replicator addAnimation:rotation forKey:@"replicatedAnimation"];

        } break;
        case AnimationStage2: {
            CALayer *dot = [CALayer layer];
            
            CGRect frame = (CGRect){{pt.x - radius, pt.y - diameter / 2}, {diameter, diameter}};
            dot.cornerRadius = diameter / 2.;
            dot.frame = frame;
            dot.backgroundColor = [UIColor whiteColor].CGColor;
            
            self.replicator.frame = self.layer.bounds;
            self.replicator.instanceCount = 5;
            self.replicator.instanceDelay = 0.2;
            CGFloat angle = (2.0 * M_PI) / self.replicator.instanceCount;
            
            self.replicator.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
            
            [self.layer addSublayer:self.replicator];
            [self.replicator addSublayer:dot];
            
            CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            rotation.toValue = @(-2.0 * M_PI);
            rotation.duration = 1.2;
            rotation.repeatCount = 1000;
            //    rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            [_replicator addAnimation:rotation forKey:@"replicatedAnimation"];

        } break;
        case AnimationStage3: {
            CALayer *dot = [CALayer layer];
            
            CGRect frame = (CGRect){{0, 0}, {diameter, diameter}};
            dot.cornerRadius = diameter / 2.;
            dot.frame = frame;
            dot.backgroundColor = [UIColor whiteColor].CGColor;
            
            [self.layer addSublayer:dot];
            
            CABasicAnimation *transform = [CABasicAnimation animationWithKeyPath:@"position.x"];
            transform.toValue = @(100);
            transform.duration = 0.2;
            transform.repeatCount = 0;
            transform.autoreverses = NO;
            

            [dot addAnimation:transform forKey:@"posX"];
            frame.origin.x = 100;
            dot.frame = frame;
            
        } break;
        default:
            break;
    }
    

}

@end
