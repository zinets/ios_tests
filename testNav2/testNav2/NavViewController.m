//
//  NavViewController.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBarHidden = YES;
}

- (void)menu:(id)sender didSelectItem:(MenuItem)menuItem {
    ControllerKind kind;
    switch (menuItem) {
        case MenuItem1:
        case MenuItem3:
            kind = ControllerKind1;
            break;
            
        case MenuItem2:
        case MenuItem4:
            kind = ControllerKind2;
            break;
    }
    [self pushViewControllerOfKind:kind animated:YES];
}

#pragma mark - public

- (void)pushViewControllerOfKind:(ControllerKind)kind animated:(BOOL)animated {
    UIViewController *ctrl = [ControllerFactory controllerByKind:kind];
    [self pushViewController:ctrl animated:animated];
}

@end
