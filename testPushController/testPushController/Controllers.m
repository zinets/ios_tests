//
//  Controller1.m
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Controllers.h"

@implementation BaseController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.color;
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){{0, 70}, {320, 30}}];
    label.font = [UIFont systemFontOfSize:20];
    label.text = self.text;
    [self.view addSubview:label];
}

@end

@implementation Controller0

- (NSString *)text {
    return @"Controller 0";
}

-(UIColor *)color {
    return [UIColor yellowColor];
}

@end

@implementation Controller1

-(void)viewDidLoad {
    [super viewDidLoad];
    button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = (CGRect){{15, 150}, {290, 40}};
    
    [button setTitle:@"push Controller 0 (yellow)" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(onButtonTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}

- (void)onButtonTap:(id)sender {
    [self.navigationController pushViewController:[Controller0 new] animated:YES];
}

- (NSString *)text {
    return @"Controller 1 with subController";
}

-(UIColor *)color {
    return [UIColor magentaColor];
}

@end

@implementation Controller2

- (NSString *)text {
    return @"Controller 2";
}

-(UIColor *)color {
    return [UIColor redColor];
}

@end