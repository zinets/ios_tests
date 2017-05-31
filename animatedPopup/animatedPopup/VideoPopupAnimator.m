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
};

@interface VideoPopupAnimator () <CAAnimationDelegate> {
    CAShapeLayer *circle2; // окружность меньшего диаметра, которая анимирует "галочку"
    CALayer *checkMarkLayer;
}
@property (nonatomic) AnimationPhase animationPhase;
@property (nonatomic, strong) UIView *animationContentView;
@property (nonatomic, weak) id <UIViewControllerContextTransitioning> transitionContext;
@end

@implementation VideoPopupAnimator

-(UIView *)animationContentView {
    if (!_animationContentView) {
        _animationContentView = [UIView new];
        _animationContentView.backgroundColor = [UIColor clearColor];
    }
    return _animationContentView;
}

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

- (void)animateAppearing:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController <ControllerAnimation> *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController <ControllerAnimation> *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = (id)toViewController.view;

    [transitionContext.containerView addSubview:fromView];
    [transitionContext.containerView addSubview:self.animationContentView];
    
    self.animationContentView.frame = fromView.frame;
    
//    [transitionContext.containerView addSubview:toView];
   
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

    // 2 круга из центра, увеличивают свой радиус и (2й) альфу до 0 за 0.4 сек
    CAShapeLayer *circle1 = [CAShapeLayer layer];
    CGFloat d1 = 68;
    circle1.frame = (CGRect){{(self.animationContentView.bounds.size.width - d1) / 2, (self.animationContentView.bounds.size.height - d1) / 2}, {d1, d1}};
    circle1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
    circle1.cornerRadius = d1 / 2;
    [self.animationContentView.layer addSublayer:circle1];

    CGFloat phase1duration = 0.4;

    {
        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase1duration;
        ag.delegate = self;
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.toValue = @0;
        opacityAnimation.duration = ag.duration;
     
        CGFloat d1e = self.animationContentView.bounds.size.width - 2 * 15;
        
        CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        frameAnimation.duration = ag.duration;
        CGPoint finalPos = (CGPoint){15, (self.animationContentView.bounds.size.height - d1e) / 2};
        CGSize finalSize = (CGSize){d1e, d1e};
        frameAnimation.toValue = [NSValue valueWithCGRect:(CGRect){finalPos, finalSize}];
        
        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerRadiusAnimation.duration = ag.duration;
        cornerRadiusAnimation.toValue = @(d1e / 2);
        
        ag.animations = @[opacityAnimation, frameAnimation, cornerRadiusAnimation];
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;
        [circle1 addAnimation:ag forKey:@"circle1phase1"];
    }
    
    circle2 = [CAShapeLayer layer];
    CGFloat d2 = 34;
    circle2.frame = (CGRect){{(self.animationContentView.bounds.size.width - d2) / 2, (self.animationContentView.bounds.size.height - d2) / 2}, {d2, d2}};
    circle2.backgroundColor = [UIColor whiteColor].CGColor;
    circle2.cornerRadius = d2 / 2;
    [self.animationContentView.layer addSublayer:circle2];
    {
        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase1duration;
        
        CGFloat d2e = 177;
        
        CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        frameAnimation.duration = ag.duration;
        CGPoint finalPos = (CGPoint){15, (self.animationContentView.bounds.size.height - d2e) / 2};
        CGSize finalSize = (CGSize){d2e, d2e};
        frameAnimation.toValue = [NSValue valueWithCGRect:(CGRect){finalPos, finalSize}];
        
        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerRadiusAnimation.duration = ag.duration;
        cornerRadiusAnimation.toValue = @(d2e / 2);
        
        ag.animations = @[frameAnimation, cornerRadiusAnimation];
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;
        [circle2 addAnimation:ag forKey:@"circle2phase1"];
    }
}

-(void)startPhase2 {
    _animationPhase = AnimationPhase2;

    {
        CGFloat phase2duration = 0.3;

        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase2duration;
        ag.delegate = self;

        CGFloat d2e = 160;

        CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        frameAnimation.duration = ag.duration;
        CGPoint finalPos = (CGPoint){15, (self.animationContentView.bounds.size.height - d2e) / 2};
        CGSize finalSize = (CGSize){d2e, d2e};
        frameAnimation.toValue = [NSValue valueWithCGRect:(CGRect){finalPos, finalSize}];

        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerRadiusAnimation.duration = ag.duration;
        cornerRadiusAnimation.toValue = @(d2e / 2);

        ag.animations = @[frameAnimation, cornerRadiusAnimation];
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;
        [circle2 addAnimation:ag forKey:@"circle2phase2"];
    }
}

-(void)startPhase3 {
    _animationPhase = AnimationPhase3;

    checkMarkLayer = [CALayer layer];
    UIImage *checkMarkImg = [UIImage imageNamed:@"check@2x.png"];
    CGSize sz = checkMarkImg.size;
    CGRect frame = (CGRect){{(self.animationContentView.bounds.size.width - sz.width) / 2, (self.animationContentView.bounds.size.height - sz.height) / 2}, sz};
    checkMarkLayer.contents = (id)checkMarkImg.CGImage;
    checkMarkLayer.frame = frame;
    [self.animationContentView.layer addSublayer:checkMarkLayer]; {
        CGFloat phase3duration = 0.5;

        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase3duration;

        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.duration = ag.duration;
        scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1)];
        scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];

        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.duration = ag.duration;
        opacityAnimation.fromValue = @0;
        opacityAnimation.toValue = @1;

        ag.animations = @[scaleAnimation, opacityAnimation];
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;
        [checkMarkLayer addAnimation:ag forKey:@"check_phase3"];
    }

    {
        CGFloat phase3duration = 0.5;

        CAAnimationGroup *ag = [CAAnimationGroup animation];
        ag.duration = phase3duration;
        ag.delegate = self;

        CGFloat d2e = 177;

        CABasicAnimation *frameAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        frameAnimation.duration = ag.duration;
        CGPoint finalPos = (CGPoint){15, (self.animationContentView.bounds.size.height - d2e) / 2};
        CGSize finalSize = (CGSize){d2e, d2e};
        frameAnimation.toValue = [NSValue valueWithCGRect:(CGRect){finalPos, finalSize}];

        CABasicAnimation *cornerRadiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        cornerRadiusAnimation.duration = ag.duration;
        cornerRadiusAnimation.toValue = @(d2e / 2);

        ag.animations = @[frameAnimation, cornerRadiusAnimation];
        ag.removedOnCompletion = NO;
        ag.fillMode = kCAFillModeForwards;
        [circle2 addAnimation:ag forKey:@"circle2phase3"];
    }
}

- (void)endAnimation {
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
            default:
                [self endAnimation];

                break;
        }
    }
}

@end
