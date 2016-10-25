//
//  TransitionAnimator.h
//
//  Created by Zinets Victor on 10/25/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
@end
