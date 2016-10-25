//
//  PushTransitionAnimator.h
//  testNav
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@end
