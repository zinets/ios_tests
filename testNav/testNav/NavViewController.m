//
//  NavViewController.m
//  testNav
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()
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
    }
    return self;
}

+ (instancetype)navigationController {
    return [NavViewController new];
}

@end
