//
//  NavViewController.m
//  testNav
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)navigationController {
    return [[NavViewController alloc] initWithRootViewController:[MenuController new]];
}

@end
