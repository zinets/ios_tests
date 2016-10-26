//
//  AnimationManager.m
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "AnimationManager.h"

#import "PushTransitionAnimator.h"
#import "UpDownTransitionAnimator.h"

@implementation AnimationManager

+ (instancetype)sharedInstance {
    static AnimationManager * inst = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [AnimationManager new];
    });
    return inst;
}

#pragma mark - <UIViewControllerTransitioningDelegate>

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    TransitionAnimator *animator = [PushTransitionAnimator new];
    animator.presenting = YES;
    
    return animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TransitionAnimator *animator = [PushTransitionAnimator new];
    animator.presenting = NO;
    
    return animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    TransitionAnimator *iAnimator = PushTransitionAnimator.new;
    iAnimator.presenting = YES;
    return iAnimator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    TransitionAnimator *iAnimator = UpDownTransitionAnimator.new;
    iAnimator.presenting = NO;
    return iAnimator;
}

#pragma mark - <UINavigationControllerDelegate>

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
#warning 
    // как поределить тип анимации??? делегат??
    TransitionAnimator *animator = nil;
    if ((navigationController.viewControllers.count < 3 && operation == UINavigationControllerOperationPush) ||
        (navigationController.viewControllers.count < 2 && operation == UINavigationControllerOperationPop)) {
        animator = [UpDownTransitionAnimator new];
    } else {
        animator = [PushTransitionAnimator new];
    }
    animator.presenting = operation == UINavigationControllerOperationPush;
    
    return animator;
}

@end
