//
// Created by Zinets Viktor on 10/4/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PhotoCropPushAnimator.h"
#import "PhotoCropController.h"
#import "ViewController.h"


@implementation PhotoCropPushAnimator {

}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    PhotoCropController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];

    CGRect toFrame = toViewController.toView.frame;
    CGRect fromFrame = fromViewController.fromView.frame;

    toViewController.toView.frame = fromFrame;

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.toView.frame = toFrame;
    } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end