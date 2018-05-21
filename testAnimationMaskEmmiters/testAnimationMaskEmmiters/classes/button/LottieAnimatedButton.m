//
//  FavButton.m
//  testAnimationMaskEmmiters
//
//  Created by Victor Zinets on 5/21/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "LottieAnimatedButton.h"

@interface PreSelectAnimationDelegateObject : NSObject <CAAnimationDelegate>
@property (nonatomic, weak) UIButton *buttonToSelect;
@property (nonatomic, copy) void (^lottieAnimation)(void);

- (instancetype)initWithButtonToSelect:(UIButton *)button;
- (instancetype)initWithAnimationBlock:(void (^)(void))animation;
@end

@implementation PreSelectAnimationDelegateObject

- (instancetype)initWithButtonToSelect:(UIButton *)button {
    if (self = [super init]) {
        self.buttonToSelect = button;
    }
    return self;
}

- (instancetype)initWithAnimationBlock:(void (^)(void))animation {
    if (self = [super init]) {
        self.lottieAnimation = animation;
    }
    return self;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if (self.buttonToSelect) {
            self.buttonToSelect.selected = YES;
        } else if (self.lottieAnimation) {
            self.lottieAnimation();
        }
    }
}

@end

@interface LottieAnimatedButton() <CAAnimationDelegate> {
    CAShapeLayer *pulseLayer;
    CALayer *iconLayer;
}
@end

@implementation LottieAnimatedButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.layer.masksToBounds = NO;
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    return self;
}

-(void)setSelected:(BOOL)selected {
    [iconLayer removeFromSuperlayer];
    [pulseLayer removeFromSuperlayer];
    if (selected) {
        // bg animation
        pulseLayer = [CAShapeLayer layer];
        pulseLayer.frame = [self bounds];
        pulseLayer.fillColor = [self backgroundColorForState:(UIControlStateSelected)].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds];
        pulseLayer.path = path.CGPath;
        [self.layer addSublayer:pulseLayer];
        
        CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transform.delegate = self;
        
        NSMutableArray *values = [NSMutableArray new];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        
        transform.values = values;
        transform.keyTimes = @[@0.0, @0.6, @1.0];
        transform.removedOnCompletion = NO;
        transform.fillMode = kCAFillModeForwards;
        transform.duration = 0.5;
        transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [pulseLayer addAnimation:transform forKey:@"1"];
        
        // icon animation
        iconLayer = [CALayer layer];
        iconLayer.frame = self.bounds;
        iconLayer.contents = (id)[self imageForState:(UIControlStateSelected)].CGImage;
        iconLayer.contentsGravity = @"center";
        iconLayer.contentsScale = 2;
        [self.layer addSublayer:iconLayer];
        
        transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        values = [NSMutableArray new];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0., 0., 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        
        transform.values = values;
        transform.keyTimes = @[@0.0, @0.3, @0.8, @1.0];
        transform.removedOnCompletion = NO;
        transform.fillMode = kCAFillModeForwards;
        transform.duration = 0.5;
        transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [iconLayer addAnimation:transform forKey:@"1"];
    } else {
        [super setSelected:NO];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [super setSelected:YES];
    }
}

- (void)setSelectedUsingAnimation:(void (^)(void))lottieAnimation atFinishPoint:(CGPoint)destPoint {
    if (self.selected) {
        self.selected = NO;
    } else {
        CGPoint fromPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGPoint toPoint = [self convertPoint:destPoint fromView:self.superview];
        BOOL directionFromLeft = toPoint.x > fromPoint.x;
        
        iconLayer = [CALayer layer];
        iconLayer.frame = self.bounds;
        iconLayer.contents = (id)[self imageForState:(UIControlStateHighlighted)].CGImage;
        iconLayer.contentsGravity = @"center";
        iconLayer.contentsScale = 2;
        [self.layer addSublayer:iconLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:fromPoint];
        [path addQuadCurveToPoint:toPoint controlPoint:(CGPoint){fromPoint.x, toPoint.y}];
        
        CAAnimationGroup *ga = [CAAnimationGroup animation];
        ga.duration = 2.4;
        
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.path = path.CGPath;
        pathAnimation.duration = ga.duration;
        pathAnimation.additive = NO;
        pathAnimation.repeatCount = 1;
        pathAnimation.calculationMode = kCAAnimationPaced;
        
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = ga.duration;
        scaleAnimation.values = @[@1, @2, @0.1];
        scaleAnimation.keyTimes = @[@0, @0.3, @1];
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotateAnimation.fromValue = @0;
        rotateAnimation.toValue = @(3 * (directionFromLeft ? M_PI : -M_PI));
        rotateAnimation.duration = ga.duration;
        rotateAnimation.repeatCount = 1;
        
        PreSelectAnimationDelegateObject *delegate;
        if (lottieAnimation) {
            delegate = [[PreSelectAnimationDelegateObject alloc] initWithAnimationBlock:lottieAnimation];
        } else {
            delegate = [[PreSelectAnimationDelegateObject alloc] initWithButtonToSelect:self];
        }
        ga.delegate = delegate;
        ga.animations = @[pathAnimation, scaleAnimation, rotateAnimation];
        
        [iconLayer addAnimation:ga forKey:@"animation"];
    }
}

@end
