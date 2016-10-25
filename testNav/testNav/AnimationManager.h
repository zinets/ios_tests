//
//  AnimationManager.h
//  testNav
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NavigationAnimator <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end

@interface AnimationManager : NSObject <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
+ (instancetype)sharedInstance;
@end
