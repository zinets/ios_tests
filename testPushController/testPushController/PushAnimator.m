//
//  PushAnimator.m
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "PushAnimator.h"

@implementation PushAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController <ControllerAnimation> *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController <ControllerAnimation> *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = (id)toViewController.view;
   
    if (!self.closing) {
        CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
        toView.frame = toFrame;
        toView.transform = CGAffineTransformMakeTranslation(toView.frame.size.width, 0);
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];      
       
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromView.transform = CGAffineTransformMakeTranslation(-fromView.frame.size.width, 0);
            toView.transform = CGAffineTransformIdentity;
            
            if ([toViewController respondsToSelector:@selector(animateAppearing:)]) {
                [toViewController animateAppearing:[self transitionDuration:transitionContext]];
            }
        } completion:^(BOOL finished) {
            fromView.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else {
        CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
        toView.frame = toFrame;
        toView.transform = CGAffineTransformMakeTranslation(-toView.frame.size.width, 0);
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.transform = CGAffineTransformIdentity;
            
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
