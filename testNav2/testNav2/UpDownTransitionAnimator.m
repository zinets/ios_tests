//
//  UpDownTransitionAnimator.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "UpDownTransitionAnimator.h"

static int const MAGIC_TAG = 0x238929;

@interface UpDownTransitionAnimator ()
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
            fromViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
            startRect.origin.y = 30;
            toViewController.view.frame = startRect;
            
            fromViewController.view.layer.cornerRadius = 5;
        } completion:^(BOOL finished) {
            { // сука, я сам не верю, что нельзя проще, но не нашел способа пока
                CGSize sz = [UIScreen mainScreen].bounds.size;
                UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
                
                [fromViewController.view.window drawViewHierarchyInRect:(CGRect){CGPointZero, sz}
                                                     afterScreenUpdates:NO];
                
                UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                UIView *fakeView = [[UIImageView alloc] initWithImage:img];
                fakeView.tag = MAGIC_TAG;
                fakeView.contentMode = UIViewContentModeTop;
                fakeView.frame = (CGRect){{0, -30}, {320, 30}};
                [toViewController.view addSubview:fakeView];
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        UIView *fakeHeader = [fromViewController.view viewWithTag:MAGIC_TAG];
        if (fakeHeader) {
            [fakeHeader removeFromSuperview];
        }
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        CGRect endRect = [transitionContext initialFrameForViewController:fromViewController];
        endRect.origin.y += endRect.size.height;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endRect;
            toViewController.view.layer.cornerRadius = 0;
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            if ([transitionContext transitionWasCancelled]) {
                [fromViewController.view addSubview:fakeHeader];
            }
        }];
    }
}

@end
