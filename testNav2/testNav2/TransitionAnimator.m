//
//  TransitionAnimator.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "TransitionAnimator.h"

@implementation TransitionAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSAssert(NO, @"override me!");
}

- (CGFloat)interactivePercent:(CGPoint)translation inBounds:(CGRect)bounds {
    return 0;
}

@end
