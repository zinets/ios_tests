//
//  FavButton.m
//  testAnimationMaskEmmiters
//
//  Created by Victor Zinets on 5/21/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "LottieAnimatedButton.h"

typedef enum {
    SelectionStageNone, // не выделеный
    SelectionStagePreselect, // выделение
    SelectionStageSelected, // выделеный
} SelectionStage;

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
}
@property (nonatomic, strong) CALayer *iconLayer;
@property (nonatomic, strong) CAShapeLayer *pulseLayer;

@property (nonatomic, copy) void (^lottieAnimation)(void);

@property (nonatomic) SelectionStage selectionStage;
@end

@implementation LottieAnimatedButton

- (void)commonInit {
    self.animationDuration = 0.7;
    self.selectionStage = SelectionStageNone;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (void)setSelected:(BOOL)selected {
    // анимация только "туда"
    if (self.animatedSelection) {
        [self setSelected:selected animated:YES];
    } else {
        [super setSelected:selected];
    }
}

#pragma #pragma mark delegate -

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [super setSelected:YES];
        self.userInteractionEnabled = YES;
    }
}

#pragma mark internal -

- (void)setSelectedUsingAnimation:(void (^)(void))lottieAnimation atFinishPoint:(CGPoint)destPoint {
    if (self.selected) {
        self.selected = NO;
    } else {
        self.userInteractionEnabled = NO;
        
        CGPoint fromPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGPoint toPoint = [self convertPoint:destPoint fromView:self.superview];
        BOOL directionFromLeft = toPoint.x > fromPoint.x;
        
        _iconLayer = [CALayer layer];
        _iconLayer.frame = self.bounds;
        _iconLayer.contents = (id)[self imageForState:(UIControlStateHighlighted)].CGImage;
        _iconLayer.contentsGravity = @"center";
        _iconLayer.contentsScale = 2;
        [self.layer addSublayer:_iconLayer];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:fromPoint];
        [path addQuadCurveToPoint:toPoint controlPoint:(CGPoint){fromPoint.x, toPoint.y}];
        
        CAAnimationGroup *ga = [CAAnimationGroup animation];
        ga.duration = self.animationDuration;
        
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
        rotateAnimation.toValue = @(0.8 * (directionFromLeft ? M_PI : -M_PI));
        rotateAnimation.duration = ga.duration;
        rotateAnimation.repeatCount = 1;
        
        PreSelectAnimationDelegateObject *delegate;
        if (lottieAnimation) {
            self.lottieAnimation = lottieAnimation;
            __weak typeof(self) weakSelf = self;
            delegate = [[PreSelectAnimationDelegateObject alloc] initWithAnimationBlock:^{
                weakSelf.lottieAnimation();
                [weakSelf.iconLayer removeFromSuperlayer];
            }];
        } else {
            delegate = [[PreSelectAnimationDelegateObject alloc] initWithButtonToSelect:self];
        }
        ga.delegate = delegate;
        ga.animations = @[pathAnimation, scaleAnimation, rotateAnimation];

        _iconLayer.transform = CATransform3DMakeScale(0., 0., 1); // мнекажется иногда редко, но - после улета "hlited" иконки она возвращалась в конце анимации назад и успевала мигнуть перед убиранием из слоя; поэтому оставлю ее размер нулевым, а потом сразу удалю - вроде пофиксило
        [_iconLayer addAnimation:ga forKey:@"animation"];
    }
}

- (void)finishSelection {
    [_iconLayer removeFromSuperlayer];
    [_pulseLayer removeFromSuperlayer];

    self.userInteractionEnabled = NO;

    // bg animation
    _pulseLayer = [CAShapeLayer layer];
    _pulseLayer.frame = [self bounds];
    _pulseLayer.fillColor = [self backgroundColorForState:(UIControlStateSelected)].CGColor;

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:_pulseLayer.bounds];
    _pulseLayer.path = path.CGPath;
    [self.layer addSublayer:_pulseLayer];

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

    [_pulseLayer addAnimation:transform forKey:@"1"];

    // icon animation
    _iconLayer = [CALayer layer];
    _iconLayer.frame = self.bounds;
    _iconLayer.contents = (id)[self imageForState:(UIControlStateSelected)].CGImage;
    _iconLayer.contentsGravity = @"center";
    _iconLayer.contentsScale = 2;
    [self.layer addSublayer:_iconLayer];

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

    [_iconLayer addAnimation:transform forKey:@"1"];

}

- (void)deselectButton {
    __weak typeof(self) weakSelf = self;
    PreSelectAnimationDelegateObject *delegate = [[PreSelectAnimationDelegateObject alloc] initWithAnimationBlock:^{
        [weakSelf.iconLayer removeFromSuperlayer];
        [weakSelf.pulseLayer removeFromSuperlayer];
    }];
    CABasicAnimation *fade1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade1.toValue = @0;
    fade1.delegate = delegate;
    [_pulseLayer addAnimation:fade1 forKey:@"fade1"];

    CABasicAnimation *fade2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade2.toValue = @0;
    [_iconLayer addAnimation:fade2 forKey:@"fade2"];
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (!animated || !self.destinationAnimationBlock) {
        self.selected = selected;
    } else {
        if (!selected) {
            [self deselectButton];
            [super setSelected:NO];
            self.selectionStage = SelectionStageNone;
        } else {
            switch (self.selectionStage) {
                case SelectionStageNone:
                    [self setSelectedUsingAnimation:self.destinationAnimationBlock atFinishPoint:self.destPoint];
                    self.selectionStage = SelectionStagePreselect;
                    break;
                case SelectionStagePreselect:
                    [self finishSelection];
                    self.selectionStage = SelectionStageSelected;
                    break;
                default:
                    break;
            }

        }
    }
}

@end
