//
//  PushAnimator.h
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavProtocols.h"

@interface PushAnimator : NSObject <NavigationAnimator>
+ (instancetype)instance;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end
