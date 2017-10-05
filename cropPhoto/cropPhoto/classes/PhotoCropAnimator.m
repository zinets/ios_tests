//
// Created by Zinets Viktor on 10/4/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PhotoCropAnimator.h"
#import "PhotoCropController.h"
#import "ViewController.h"


@implementation PhotoCropAnimator {

}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.operation == UINavigationControllerOperationPush) {
        PhotoCropController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        ViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

        [[transitionContext containerView] addSubview:toViewController.view];

        CGRect toFrame = toViewController.toView.frame;
        CGRect fromFrame = fromViewController.fromView.frame;

        toViewController.toView.frame = fromFrame;
        toViewController.toView.backgroundColor = [UIColor clearColor];
        toViewController.toView.contentMode = UIViewContentModeScaleAspectFill;

        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.toView.frame = toFrame;
            toViewController.toView.backgroundColor = [UIColor lightGrayColor];
            toViewController.toView.contentMode = UIViewContentModeScaleAspectFit;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else { // ну типа остается поп и нон, но что за фигня придираться к мелочам
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeTranslation(0, fromViewController.view.bounds.size.height);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
