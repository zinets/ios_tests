//
//  ControllerFabric.m
//  testNav
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ControllerFactory.h"

#import "ViewController1.h"
#import "ViewController2.h"

#import "AnimationManager.h"

@implementation ControllerFactory

+ (UIViewController *)controllerByKind:(ControllerKind)kind {
    UIViewController *res = nil;
    switch (kind) {
        case ControllerKind1:
            res = [ViewController1 new];
            break;
            
        case ControllerKind2:
            res = [ViewController2 new];
            break;
    }
    res.transitioningDelegate = [AnimationManager sharedInstance];
    return res;
}

@end
