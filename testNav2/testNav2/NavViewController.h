//
//  NavViewController.h
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuController.h"
#import "ControllerFactory.h"

@interface NavViewController : UINavigationController <MenuControllerDelegate>
- (void)pushViewControllerOfKind:(ControllerKind)kind animated:(BOOL)animated;
@end
