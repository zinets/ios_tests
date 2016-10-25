//
//  TransitionAnimator.m
//
//  Created by Zinets Victor on 10/25/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "TransitionAnimator.h"

@implementation TransitionAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

// virtual method - u have to override it
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

@end
