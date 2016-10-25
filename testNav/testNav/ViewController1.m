//
//  ViewController1.m
//  testNav
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController1.h"
#import "defines.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    self.viewTitle = @"Я вьюконтроллер 1!";
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"Create instance of view controller #2" forState:(UIControlStateNormal)];
    btn.frame = (CGRect){{5, 100}, {310, 44}};
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)onTap:(id)sender {
#if (USE_PUSH)
    [self.navigationController pushViewController:[ControllerFactory controllerByKind:(ControllerKind2)] animated:YES];
#else
    [self presentViewController:[ControllerFactory controllerByKind:(ControllerKind2)] animated:YES completion:nil];
#endif
}

@end
