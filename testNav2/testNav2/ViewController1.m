//
//  ViewController1.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController1.h"

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

}

@end
