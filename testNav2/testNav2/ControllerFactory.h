//
//  ControllerFactory.h
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ControllerKind) {
    ControllerKind1,
    ControllerKind2,
};

@interface ControllerFactory : NSObject
+ (UIViewController *)controllerByKind:(ControllerKind)kind;
+ (Class)controllerClassForKind:(ControllerKind)kind;
@end
