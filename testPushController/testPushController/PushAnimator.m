//
//  PushAnimator.m
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "PushAnimator.h"

@implementation PushAnimator

+ (instancetype)instance {
    static PushAnimator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController <ControllerAnimation> *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController <ControllerAnimation> *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = (id)toViewController.view;
   
    if (self.operation == UINavigationControllerOperationPush) {
        CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
        toView.frame = toFrame;
        toView.transform = CGAffineTransformMakeTranslation(toView.frame.size.width, 0);
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//            fromView.transform = CGAffineTransformMakeTranslation(-fromView.frame.size.width, 0);
            toView.transform = CGAffineTransformIdentity;
            
            if ([toViewController respondsToSelector:@selector(animateAppearing:)]) {
                [toViewController animateAppearing:[self transitionDuration:transitionContext]];
            }
            if ([fromViewController respondsToSelector:@selector(animateDisappearing:)]) {
                [fromViewController animateDisappearing:[self transitionDuration:transitionContext]];
            }
                    } completion:^(BOOL finished) {
            fromView.transform = CGAffineTransformIdentity;
            
            UIView *snapshot = [fromView snapshotViewAfterScreenUpdates:NO];
            [toView insertSubview:snapshot atIndex:0];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
        toView.frame = toFrame;
//        toView.transform = CGAffineTransformMakeTranslation(-toView.frame.size.width, 0);
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.transform = CGAffineTransformIdentity;
            fromView.alpha = 0;
            if ([toViewController respondsToSelector:@selector(animateAppearing:)]) {
                [toViewController animateAppearing:[self transitionDuration:transitionContext]];
            }            
            if ([fromViewController respondsToSelector:@selector(animateDisappearing:)]) {
                [fromViewController animateDisappearing:[self transitionDuration:transitionContext]];
            }
        } completion:^(BOOL finished) {
            fromView.alpha = 1;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}


@end
