//
//  ControllerFactory.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ControllerFactory.h"
#import "ViewController1.h"
#import "ViewController2.h"

@implementation ControllerFactory

+ (BaseViewController *)controllerByKind:(ControllerKind)kind {
    return [[self controllerClassForKind:kind] new];
}

+ (Class)controllerClassForKind:(ControllerKind)kind {
    Class res = Nil;
    switch (kind) {
        case ControllerKind1:
            res = [ViewController1 class];
            break;
        case ControllerKind2:
            res = [ViewController2 class];
            break;
        default:
            break;
    }
    return res;
}

@end
