//
//  PushAnimator.h
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Controllers.h"

@interface PushAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) BOOL closing;
@end
