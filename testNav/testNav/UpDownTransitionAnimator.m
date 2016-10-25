//
//  UpDownTransitionAnimator.m
//
//  Created by Zinets Victor on 10/25/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "UpDownTransitionAnimator.h"

@interface UpDownTransitionAnimator ()
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> context;
@property (nonatomic, weak) UIView *view;
@end

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
    
    self.context = transitionContext;
    
    if (self.presenting) {
        self.view = toViewController.view;
        
        CGRect endRect = [UIScreen mainScreen].bounds;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        __block CGRect startRect = endRect;
        startRect.origin.y += startRect.size.height;
        toViewController.view.frame = startRect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
            startRect.origin.y = 30;
            toViewController.view.frame = startRect;
            
            fromViewController.view.layer.cornerRadius = 5;
        } completion:^(BOOL finished) {
            if (finished) {
                [transitionContext finishInteractiveTransition];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }
        }];
    } else {
        self.view = fromViewController.view;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        CGRect endRect = [transitionContext initialFrameForViewController:fromViewController];
        endRect.origin.y += endRect.size.height;
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
            fromViewController.view.frame = endRect;
            toViewController.view.layer.cornerRadius = 0;
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
#warning
            // и тут тот же вопрос
            UIView *containerHost = transitionContext.containerView.superview;
            [transitionContext finishInteractiveTransition];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            [containerHost addSubview:toViewController.view];
        }];
    }
}

@end
