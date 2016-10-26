//
//  NavViewController.h
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuController.h"
#import "ControllerFactory.h"

@interface NavViewController : UINavigationController
+ (instancetype)navigationController;

- (UIViewController *)sender:(UIViewController *)sender wantAddNewControllerByKind:(ControllerKind)kind;
@end
