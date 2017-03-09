//
// Created by Zinets Victor on 3/9/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

#import "ParticlesView.h"

@interface Particle : CAShapeLayer {
    CGFloat transformAngle;
    CGFloat sinA, cosA;
}
- (void)move;
@end

@implementation Particle

- (instancetype)init {
    self = [super init];
    if (self) {
        transformAngle = arc4random_uniform(650) / 100.;
        sinA = sin(transformAngle);
        cosA = cos(transformAngle);

        self.affineTransform = CGAffineTransformMakeRotation(transformAngle);
    }

    return self;
}

- (void)move {
    CGRect frm = self.frame;
    frm.origin.y += cosA * 0.07;
    frm.origin.x += sinA * 0.05;

    if (!CGRectContainsRect(self.superlayer.bounds, frm)) {
        transformAngle = arc4random_uniform(650) / 100.;
        sinA = sin(transformAngle);
        cosA = cos(transformAngle);
    }

    self.frame = frm;
}

@end


@implementation ParticlesView {
    CADisplayLink *updateTimer;
    NSMutableArray <Particle *> *particles;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger count = 50;
        particles = [NSMutableArray arrayWithCapacity:count];

        for (int x = 0; x < count; x++) {
            UIBezierPath *particlePath = [UIBezierPath bezierPath]; {
                [particlePath moveToPoint:CGPointZero];

                CGFloat l = 10 + arc4random() % 10;
                CGFloat angle = M_PI / 6.;
                CGFloat y = l * sin(angle);
                CGFloat x = l * cos(angle);
                [particlePath addLineToPoint:(CGPoint){x, y}];

                y = -y;
                [particlePath addLineToPoint:(CGPoint){x, y}];
                [particlePath closePath];
            }

            Particle *layer1 = [Particle layer];
            _particleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
            layer1.fillColor = _particleColor.CGColor;
            layer1.strokeColor = [UIColor clearColor].CGColor;
            layer1.path = particlePath.CGPath;

            [particles addObject:layer1];
        }

        [particles enumerateObjectsUsingBlock:^(CALayer *obj, NSUInteger idx, BOOL *stop) {
            CGPoint origin = (CGPoint){arc4random_uniform(self.bounds.size.width),
                    arc4random_uniform(self.bounds.size.height)};
            CGRect frm = obj.frame;
            frm.origin = origin;
            obj.frame = frm;

            [self.layer addSublayer:obj];
        }];
    }

    return self;
}

- (void)didMoveToSuperview {
    updateTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTimerFired:)];
    [updateTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeFromSuperview {
    [updateTimer removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [super removeFromSuperview];
}

- (void)onTimerFired:(CADisplayLink *)onTimerFired {
    [particles enumerateObjectsUsingBlock:^(Particle *obj, NSUInteger idx, BOOL *stop) {
        [obj move];
    }];
}

#pragma mark - setters

- (void)setParticleColor:(UIColor *)particleColor {
    _particleColor = particleColor;
    [particles enumerateObjectsUsingBlock:^(Particle *obj, NSUInteger idx, BOOL *stop) {
        obj.fillColor = _particleColor.CGColor;
    }];
}

@end