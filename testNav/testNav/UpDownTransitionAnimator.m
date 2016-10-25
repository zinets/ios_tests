//
//  UpDownTransitionAnimator.m
//
//  Created by Zinets Victor on 10/25/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "UpDownTransitionAnimator.h"

@implementation UpDownTransitionAnimator

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        CGRect endRect = [UIScreen mainScreen].bounds;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        __block CGRect startRect = endRect;
        startRect.origin.y += startRect.size.height;
        toViewController.view.frame = startRect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
            startRect.origin.y = 30;
            toViewController.view.frame = startRect;
            
            fromViewController.view.layer.cornerRadius = 5;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        CGRect endRect = [transitionContext initialFrameForViewController:fromViewController];
        endRect.origin.y += endRect.size.height;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endRect;
            toViewController.view.layer.cornerRadius = 0;
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            UIView *containerHost = transitionContext.containerView.superview;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [containerHost addSubview:toViewController.view];
        }];
    }
}

@end
