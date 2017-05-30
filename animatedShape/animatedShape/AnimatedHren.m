//
//  AnimatedHren.m
//  animatedShape
//
//  Created by Zinets Viktor on 5/24/17.
//  Copyright © 2017 Zinets Viktor. All rights reserved.
//

#import "AnimatedHren.h"

typedef NS_ENUM(NSUInteger, Stage) {
    StageBegin,
    StagePhase1Done,
};

@interface AnimatedHren () <CAAnimationDelegate> {
    CAShapeLayer *shapeLayer;
}
@property (nonatomic) Stage stage;
@end

@implementation AnimatedHren

-(void)setup {
    CGPoint c = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
    CGFloat radii = MIN(self.bounds.size.width / 2, self.bounds.size.height /2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:c
                    radius:radii
                startAngle:-M_PI_2
                  endAngle:M_PI_2
                 clockwise:NO];
    [path addArcWithCenter:c
                    radius:radii
                startAngle:M_PI_2
                  endAngle:-M_PI_2
                 clockwise:NO];
    [path closePath];
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = path.CGPath;
    
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 2;
    
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0;

    
    [self.layer addSublayer:shapeLayer];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(void)animate {
    [self startPhase1];
}

-(void)startPhase1 {
    shapeLayer.strokeStart = 0.;
    shapeLayer.strokeEnd = 0.;
    self.stage = StageBegin;
    
    CABasicAnimation *a = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    a.toValue = @(0.9);
    a.removedOnCompletion = NO;
    a.fillMode = kCAFillModeForwards;
    a.duration = 1.;
    
    a.delegate = self;
    
    [shapeLayer addAnimation:a forKey:@"animation"];
}

-(void)startPhase2 {
    shapeLayer.strokeEnd = 0.9;
    
    CABasicAnimation *a1 = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    a1.fromValue = @(0.);
    a1.toValue = @(1.);
    a1.removedOnCompletion = NO;
    a1.fillMode = kCAFillModeForwards;
    a1.duration = 1.;
    
    CABasicAnimation *a2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    a2.toValue = @(1.);
    a2.removedOnCompletion = NO;
    a2.fillMode = kCAFillModeForwards;
    a2.duration = .5;
    
    CAAnimationGroup *g = [CAAnimationGroup animation];
    g.delegate = self;
    g.animations = @[a1, a2];
    g.removedOnCompletion = NO;
    g.fillMode = kCAFillModeBoth;
    g.duration = 1.;
    
    [shapeLayer addAnimation:g forKey:@"animation"];
    
}

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    switch (self.stage) {
        case StageBegin:
            self.stage = StagePhase1Done;
            [self startPhase2];
            
            break;
        case StagePhase1Done:
            shapeLayer.strokeStart = 0.;
            shapeLayer.strokeEnd = 0.;
            
            [self startPhase1];
            break;
        default:
            break;
    }
}

@end
