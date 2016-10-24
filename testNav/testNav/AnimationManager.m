//
//  AnimationManager.m
//  testNav
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "AnimationManager.h"

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
    return nil;
}

@end
