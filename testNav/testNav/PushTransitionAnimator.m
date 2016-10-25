//
//  PushTransitionAnimator.m
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "PushTransitionAnimator.h"

@implementation PushTransitionAnimator

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        CGRect endRect = [UIScreen mainScreen].bounds;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startRect = endRect;
        startRect.origin.x += startRect.size.width;
        toViewController.view.frame = startRect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endRect;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        CGRect endRect = [transitionContext initialFrameForViewController:fromViewController];
        endRect.origin.x += endRect.size.width;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endRect;
        } completion:^(BOOL finished) {
#warning
            // это выглядит неправильно; я вью контроллера вставляю хз куда            
            UIView *containerHost = transitionContext.containerView.superview;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [containerHost addSubview:toViewController.view];
        }];
    }
}

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        CGRect endRect = [UIScreen mainScreen].bounds;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startRect = endRect;
        startRect.origin.x += startRect.size.width;
        toViewController.view.frame = startRect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.frame = endRect;
        } completion:^(BOOL finished) {
            [transitionContext finishInteractiveTransition];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        CGRect endRect = [transitionContext initialFrameForViewController:fromViewController];
        endRect.origin.x += endRect.size.width;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endRect;
        } completion:^(BOOL finished) {
#warning
            // а тут нужен тот странный код?
            UIView *containerHost = transitionContext.containerView.superview;
            [transitionContext finishInteractiveTransition];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [containerHost addSubview:toViewController.view];
        }];
    }
}

@end
