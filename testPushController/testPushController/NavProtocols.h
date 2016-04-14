//
//  NavProtocols.h
//  testPushController
//
//  Created by Zinets Victor on 4/14/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#ifndef NavProtocols_h
#define NavProtocols_h

@protocol NavigationAnimator <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end

@protocol CustomNavigationAnimation <NSObject>
@property (nonatomic, strong) NSObject <NavigationAnimator> *animator;
@end

@protocol ControllerAnimation <NSObject>
@optional
- (void)animateAppearing:(CGFloat)duration;
- (void)animateDisappearing:(CGFloat)duration;
@end

#endif /* NavProtocols_h */
