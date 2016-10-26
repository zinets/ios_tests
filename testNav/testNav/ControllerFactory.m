//
//  ControllerFabric.m
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ControllerFactory.h"
#import "defines.h"

#import "ViewController1.h"
#import "ViewController2.h"

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
    
    return res;
}

@end
