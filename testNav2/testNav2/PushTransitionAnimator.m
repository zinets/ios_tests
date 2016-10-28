//
//  PushTransitionAnimator.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "PushTransitionAnimator.h"

@implementation PushTransitionAnimator

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect rect = [UIScreen mainScreen].bounds;
        // пушаные контроллеры всегда поверх других и значит сверху всегда нужна дырка
        rect.origin.x += rect.size.width;
        rect.origin.y = TransitionAnimator.topOffsetValue;
        rect.size.height -= TransitionAnimator.topOffsetValue;
        toViewController.view.frame = rect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            CGRect endRect = rect;
            endRect.origin.x = 0;
            
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
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (CGFloat)interactivePercent:(CGPoint)translation inBounds:(CGRect)bounds {
    CGFloat percent = 0;
    if (!self.presenting) { // интерактивно сделать пуш мы не можем
        percent = fabs(MAX(0, translation.x) / bounds.size.width);
    }
    
    return percent;
}


@end
