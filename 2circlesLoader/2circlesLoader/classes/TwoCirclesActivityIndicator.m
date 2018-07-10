//
// Created by Victor Zinets on 7/10/18.
// Copyright (c) 2018 Dolboyob Inc. All rights reserved.
//

#import "TwoCirclesActivityIndicator.h"

typedef enum {
    TwoCirclesActivityAnimationStageStopped,
    TwoCirclesActivityAnimationStageStarting,
    TwoCirclesActivityAnimationStageRotating,
    TwoCirclesActivityAnimationStageStopping,
} TwoCirclesActivityAnimationStage;

@interface TwoCirclesActivityIndicator() <CAAnimationDelegate> {
    TwoCirclesActivityAnimationStage animationStage;
}
@property (nonatomic, strong) CAShapeLayer *layer1;
@property (nonatomic, strong) CAShapeLayer *layer2;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *line1Color;
@property (nonatomic, strong) UIColor *line2Color;
@end

@implementation TwoCirclesActivityIndicator {

}

#pragma mark getters -

- (CAShapeLayer *)layer1 {
    if (!_layer1) {
        _layer1 = [CAShapeLayer new];
        CGRect frame = self.bounds;
        _layer1.frame = frame;
        _layer1.strokeColor = self.line1Color.CGColor;
        _layer1.fillColor = [UIColor clearColor].CGColor;

        CGPoint center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:M_PI_4
                                                          endAngle:3 * M_PI_4
                                                         clockwise:NO];
        _layer1.strokeStart =
        _layer1.strokeEnd = 0;
        _layer1.lineWidth = self.lineWidth;
        _layer1.lineCap = kCALineCapRound;

        _layer1.path = path.CGPath;
    }

    return _layer1;
}

- (CAShapeLayer *)layer2 {
    if (!_layer2) {
        _layer2 = [CAShapeLayer new];
        CGRect frame = self.bounds;
        CGPoint center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) / 2 - 8;
        _layer2.frame = frame;
        _layer2.strokeColor = self.line2Color.CGColor;
        _layer2.fillColor = [UIColor clearColor].CGColor;

        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:-M_PI_4
                                                          endAngle:-3 * M_PI_4
                                                         clockwise:YES];
        _layer2.strokeStart = 0;
        _layer2.strokeEnd = 0;
        _layer2.lineWidth = self.lineWidth;
        _layer2.lineCap = kCALineCapRound;

        _layer2.path = path.CGPath;
    }

    return _layer2;
}

#pragma mark public -

- (void)commonInit {
    _lineWidth = 3;
    _line1Color = [UIColor lightGrayColor];
    _line2Color = [UIColor lightGrayColor];

    [self.layer addSublayer:self.layer1];
    [self.layer addSublayer:self.layer2];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)startAnimation {
    if (animationStage == TwoCirclesActivityAnimationStageStopped) {
        [self setStartingStage];
    }
}

- (void)stopAnimation {
    animationStage = TwoCirclesActivityAnimationStageStopping;
}

#pragma mark animation -

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    switch (animationStage) {
        case TwoCirclesActivityAnimationStageStarting:
            [CATransaction setDisableActions:YES];
            self.layer1.strokeEnd = 1;
            self.layer2.strokeEnd = 1;
            [CATransaction setDisableActions:NO];

            [self setRotatingStage];

            break;
        case TwoCirclesActivityAnimationStageRotating:
            [self setRotatingStage];
            break;
        case TwoCirclesActivityAnimationStageStopping:
            [CATransaction setDisableActions:YES];
            self.layer1.strokeStart = 0;
            self.layer1.strokeEnd = 1;

            self.layer2.strokeStart = 0;
            self.layer2.strokeEnd = 1;
            [CATransaction setDisableActions:NO];

            [self setFinalStage];
            break;
        case TwoCirclesActivityAnimationStageStopped:
            [self setInitialState];
            break;
    }
}

- (CABasicAnimation *)rotatingAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 1.5;
    animation.toValue = @0;
    animation.fromValue = @(M_PI * 2);

    return animation;
}

- (CABasicAnimation *)ccwRotatingAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 1.5;
    animation.fromValue = @0;
    animation.toValue = @(M_PI * 2);

    return animation;
}

-(CABasicAnimation *)startingAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.3;
    animation.fromValue = @0;
    animation.toValue = @1;

    return animation;
}

-(CABasicAnimation *)stoppingAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.duration = 1.3;
    animation.fromValue = @0;
    animation.toValue = @1;

    return animation;
}


- (void)setStartingStage {
    [self.layer1 removeAllAnimations];
    [self.layer2 removeAllAnimations];

    CABasicAnimation *animation = self.startingAnimation;
    animation.delegate = self;
    [self.layer1 addAnimation:animation forKey:@"1"];
    [self.layer2 addAnimation:self.startingAnimation forKey:@"2"];
    animationStage = TwoCirclesActivityAnimationStageStarting;
}

- (void)setRotatingStage {
    CABasicAnimation *animation = self.rotatingAnimation;
    animation.delegate = self;
    [self.layer1 addAnimation:animation forKey:@"1"];
    [self.layer2 addAnimation:self.ccwRotatingAnimation forKey:@"2"];
    animationStage = TwoCirclesActivityAnimationStageRotating;
}

- (void)setFinalStage {
    CABasicAnimation *animation = self.stoppingAnimation;
    animation.delegate = self;
    [self.layer1 addAnimation:animation forKey:@"1"];
    [self.layer2 addAnimation:self.stoppingAnimation forKey:@"2"];
    animationStage = TwoCirclesActivityAnimationStageStopped;
}

- (void)setInitialState {
    [CATransaction setDisableActions:YES];
    self.layer1.strokeStart = 0;
    self.layer1.strokeEnd = 0;

    self.layer2.strokeStart = 0;
    self.layer2.strokeEnd = 0;
    [CATransaction setDisableActions:NO];
}


@end