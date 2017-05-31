//
//  VideoPopupAnimator.m
//  animatedPopup
//
//  Created by Zinets Viktor on 5/30/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import "VideoPopupAnimator.h"

typedef NS_ENUM(NSUInteger, AnimationPhase) {
    AnimationStopped, // тупо начальная фаза - "и не было ничего"
    AnimationPhase1, // появление 2х окружностей, анимация размера и прозрачности
    AnimationPhase2, // уменьшение диаметра круга до 162
    AnimationPhase3, // увеличение диаметра круга; появление, увеличение размера и прозрачности "галочки"
    AnimationPhase4, // увеличение круга и галочки в 1.1 за 64 кадра
    AnimationPhase5, // белый круг и галочка убираются; добавляется зеленый круг; размер и кривизна меняются дло максимального размера, прозрачность падает до 0; зеленый круг работает как маска для вью
};

@interface VideoPopupAnimator () <CAAnimationDelegate> {
}
@property (nonatomic) AnimationPhase animationPhase;
@property (nonatomic, strong) UIView *animationContentView;
@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;

@property (nonatomic, strong) CAShapeLayer *light; // названия слоев - из "принципла", для простоты
@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) CALayer *check;

@end

@implementation VideoPopupAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        _circleDiameter = 160;
        _lightCircleDiameter = 300;
        _shapeColor = [UIColor colorWithRed:115./255. green:184./255. blue:56./255. alpha:1];
    }

    return self;
}


-(UIView *)animationContentView {
    if (!_animationContentView) {
        _animationContentView = [UIView new];
        _animationContentView.backgroundColor = [UIColor clearColor];
    }
    return _animationContentView;
}

- (CAShapeLayer *)circle {
    if (!_circle) {
        CGFloat d = self.circleDiameter;
        _circle = [CAShapeLayer layer];
        _circle.frame = (CGRect){{(self.animationContentView.bounds.size.width - d) / 2, (self.animationContentView.bounds.size.height - d) / 2}, {d, d}};
        _circle.backgroundColor = [UIColor whiteColor].CGColor;
        _circle.cornerRadius = d / 2;
    }
    return _circle;
}

- (CAShapeLayer *)light {
    if (!_light) {
        CGFloat d = self.lightCircleDiameter;
        _light = [CAShapeLayer layer];
        _light.frame = (CGRect){{(self.animationContentView.bounds.size.width - d) / 2, (self.animationContentView.bounds.size.height - d) / 2}, {d, d}};
        _light.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor ;
        _light.cornerRadius = d / 2;
    }
    return _light;
}

- (CAShapeLayer *)check {
    if (!_check) {
        _check = [CALayer layer];
        UIImage *checkMarkImg = [UIImage imageNamed:@"check@2x.png"];
        CGSize sz = checkMarkImg.size;
        CGRect frame = (CGRect){{(self.animationContentView.bounds.size.width - sz.width) / 2, (self.animationContentView.bounds.size.height - sz.height) / 2}, sz};
        _check.contents = (id)checkMarkImg.CGImage;
        _check.frame = frame;
    }
    return _check;
}

#pragma mark -

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return .5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    if (self.operation == UINavigationControllerOperationPush) {
        [self animateAppearing:transitionContext];
    } else {
        [self animateDisappearing:transitionContext];
    }
}

#pragma mark -

- (void)animateAppearing:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController <ControllerAnimation> *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController <ControllerAnimation> *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = (id)toViewController.view;

    // старое вью
    [transitionContext.containerView addSubview:fromView];
    // новое вью - до определенного момента его не должно быть видно
    toView.layer.opacity = 0;
    [transitionContext.containerView addSubview:toView];

    // вью с анимацией
    self.animationContentView.frame = fromView.frame;
    [transitionContext.containerView addSubview:self.animationContentView];

    [self startAnimation];
}

- (void)animateDisappearing:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController <ControllerAnimation> *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController <ControllerAnimation> *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = (id)toViewController.view;

    [self.animationContentView removeFromSuperview];
    _animationContentView = nil;

    [transitionContext.containerView addSubview:toView];

    [transitionContext completeTransition:YES];
}

#pragma mark - animation

-(void)startAnimation {
    [self startPhase1];
}

-(void)startPhase1 {
    _animationPhase = AnimationPhase1;
    CGFloat phase1duration = 0.44;

    // light
    [self.animationContentView.layer addSublayer:self.light];
    {
        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase1duration;
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;
        ag.delegate = self;

        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1)];
        scaleAnimation.duration = ag.duration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @0.7;
        opacityAnimation.toValue = @0;
        opacityAnimation.beginTime = 0.16;
        opacityAnimation.duration = ag.duration - 0.16;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        ag.animations = @[opacityAnimation, scaleAnimation];

        [self.light addAnimation:ag forKey:@"light_phase1"];
    }

    // circle
    [self.animationContentView.layer addSublayer:self.circle];
    {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        scaleAnimation.duration = phase1duration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;

        [self.circle addAnimation:scaleAnimation forKey:@"circle_phase1"];
    }
}

-(void)startPhase2 {
    _animationPhase = AnimationPhase2;
    CGFloat phase2duration = 0.3;

    // circle
    {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.duration = phase2duration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.delegate = self;

        [self.circle addAnimation:scaleAnimation forKey:@"circle_phase2"];
    }
}

-(void)startPhase3 {
    _animationPhase = AnimationPhase3;
    CGFloat phase3duration = 0.3;
    // circle
    {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        scaleAnimation.duration = phase3duration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;

        [self.circle addAnimation:scaleAnimation forKey:@"circle_phase3"];
    }
    // check
    [self.animationContentView.layer addSublayer:self.check];
    {
        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase3duration;
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;
        ag.delegate = self;

        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.duration = ag.duration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @0;
        opacityAnimation.toValue = @1;
        opacityAnimation.duration = ag.duration;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        ag.animations = @[scaleAnimation, opacityAnimation];
        [self.check addAnimation:ag forKey:@"check_phase3"];
    }
}

-(void)startPhase4 {
    _animationPhase = AnimationPhase4;
    CGFloat phase4duration = 1.;

    // check
    {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        scaleAnimation.duration = phase4duration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.delegate = self;

        [self.check addAnimation:scaleAnimation forKey:@"check_phase4"];
    }

    // circle
    {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)];
        scaleAnimation.duration = phase4duration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;

        [self.circle addAnimation:scaleAnimation forKey:@"circle_phase4"];
    }
}

-(void)startPhase5 {
    _animationPhase = AnimationPhase5;
    CGFloat phase5duration = 0.3;

    // check
    [self.check removeFromSuperlayer];

    // circle
    self.circle.backgroundColor = self.shapeColor.CGColor;
    {
        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase5duration;
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;

        CGFloat i = self.animationContentView.bounds.size.height;

        CASpringAnimation *frameAnimation = [CASpringAnimation animationWithKeyPath:@"bounds"];
        frameAnimation.duration = ag.duration;
        CGRect frame = (CGRect){{(self.animationContentView.bounds.size.width - i) / 2, (self.animationContentView.bounds.size.height - i) / 2}, {i, i}};
        frameAnimation.toValue = [NSValue valueWithCGRect:frame];
        frameAnimation.damping = 20;
        frameAnimation.stiffness = 300;

        CASpringAnimation *cornerRadiusAnimation = [CASpringAnimation animationWithKeyPath:@"cornerRadius"];
        cornerRadiusAnimation.duration = ag.duration;
        cornerRadiusAnimation.toValue = @(i / 2);
        cornerRadiusAnimation.damping = 20;
        cornerRadiusAnimation.stiffness = 300;

        ag.animations = @[frameAnimation, cornerRadiusAnimation];
        [self.circle addAnimation:ag forKey:@"circle_phase5"];
    }

    

    // content
    UIViewController <ControllerAnimation> *toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = (id)toViewController.view;
    toView.layer.mask = self.circle;
    toView.layer.masksToBounds = YES;
    {
        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase5duration;
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;
        ag.delegate = self;

        CASpringAnimation *scaleAnimation = [CASpringAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnimation.duration = ag.duration;
        scaleAnimation.damping = 20;
        scaleAnimation.stiffness = 300;
        //timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        CASpringAnimation *opacityAnimation = [CASpringAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @0;
        opacityAnimation.toValue = @1;
        opacityAnimation.duration = ag.duration;
        opacityAnimation.damping = 20;
        opacityAnimation.stiffness = 300;
        //timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        ag.animations = @[scaleAnimation, opacityAnimation];

        [toView.layer addAnimation:ag forKey:@"toView_phase5"];
    }
}

- (void)endAnimation {
    [self.animationContentView removeFromSuperview];
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
}

#pragma mark - delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        switch (self.animationPhase) {
            case AnimationPhase1:
                [self startPhase2];
                break;
            case AnimationPhase2:
                [self startPhase3];
                break;
            case AnimationPhase3:
                [self startPhase4];
                break;
            case AnimationPhase4:
                [self startPhase5];
                break;
            default:
                [self endAnimation];
                break;
        }
    }
}

@end
