//
//  NavViewController.m
//  testNav
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavViewController.h"

#import "ViewController1.h"
#import "ViewController2.h"

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
            [self pushViewController:[ViewController1 new] animated:YES];
        } break;
        case MenuItem2: {
            [self pushViewController:[ViewController2 new] animated:YES];
        } break;
        default:
            NSLog(@"selected %@", @(menuItem));
            break;
    }
}

@end
