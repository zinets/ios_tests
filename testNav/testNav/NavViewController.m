//
//  NavViewController.m
//  testNav
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavViewController.h"

#import "ControllerFactory.h"
#import "AnimationManager.h"

@interface NavViewController () <MenuControllerDelegate>
@property (nonatomic, strong) MenuController *menuCtrl;
@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

-(instancetype)init {
    MenuController *mc = [MenuController new];
    if (self = [super initWithRootViewController:mc]) {
        self.delegate = [AnimationManager sharedInstance];
        self.menuCtrl = mc;
        self.menuCtrl.delegate = self;
    }
    return self;
}

+ (instancetype)navigationController {
    return [NavViewController new];
}

#pragma mark - <MenuControllerDelegate>

- (void)menu:(id)sender didSelectItem:(MenuItem)menuItem {
    switch (menuItem) {
        case MenuItem1: {
            [self presentViewController:[ControllerFactory controllerByKind:(ControllerKind1)] animated:YES completion:^{
                
            }];
//            [self pushViewController:[ControllerFactory controllerByKind:(ControllerKind1)] animated:YES];
        } break;
        case MenuItem2: {
            [self pushViewController:[ControllerFactory controllerByKind:(ControllerKind2)] animated:YES];
        } break;
        case MenuItem3: {
            [self pushViewController:[ControllerFactory controllerByKind:(ControllerKind1)] animated:YES];
        } break;
        case MenuItem4: {
            [self pushViewController:[ControllerFactory controllerByKind:(ControllerKind2)] animated:YES];
        } break;
        default:
            NSLog(@"selected %@", @(menuItem));
            break;
    }
}


@end
