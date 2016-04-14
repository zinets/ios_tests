//
//  ViewController.h
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "debug.h"
#import "Controllers.h"

@protocol CustomNavigationAnimation <NSObject>
@property (nonatomic, strong) NSObject <UIViewControllerAnimatedTransitioning> *animator;
@end

@interface ViewController : UIViewController <CustomNavigationAnimation>

@end

