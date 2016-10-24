//
//  ViewController2.m
//  testNav
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.viewTitle = @"Я вьюконтроллер 2!";

    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"Create instance of view controller #1" forState:(UIControlStateNormal)];
    btn.frame = (CGRect){{5, 150}, {310, 44}};
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)onTap:(id)sender {
    [self.navigationController pushViewController:[ControllerFabric controllerByKind:(ControllerKind1)] animated:YES];
}


@end
