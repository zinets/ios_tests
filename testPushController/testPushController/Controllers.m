//
//  Controller1.m
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Controllers.h"
#import "PushAnimator.h"

@implementation BaseController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = self.color;
    
    label = [[UILabel alloc] initWithFrame:(CGRect){{0, 70}, {320, 30}}];
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

-(void)animateAppearing:(CGFloat)duration {
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:duration animations:^{
        self.view.backgroundColor = [self color];
    }];
}

-(void)animateDisappearing:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        self.view.backgroundColor = [UIColor clearColor];
    }];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.frame = (CGRect){{15, 150}, {290, 40}};
    
    [button setTitle:@"push Controller 1 (custom)" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(onButtonTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}

- (void)onButtonTap:(id)sender {
    [self.navigationController pushViewController:[Controller1 new] animated:YES];
}

@end

@implementation Controller1

-(instancetype)init {
    if (self = [super init]) {
        self.animator = [PushAnimator instance];
    }
    return self;
}

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
    return [UIColor clearColor];
}

@end

@implementation Controller2

- (NSString *)text {
    return @"Controller 2";
}

-(UIColor *)color {
    return [UIColor redColor];
}

-(void)animateAppearing:(CGFloat)duration {
    label.transform = CGAffineTransformMakeRotation(10);
    label.transform = CGAffineTransformScale(label.transform, 0.1, 0.1);
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformIdentity;
        self.view.backgroundColor = [self color];
    }];
}

-(void)animateDisappearing:(CGFloat)duration {
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeRotation(10);
        label.transform = CGAffineTransformScale(label.transform, 0.1, 0.1);
        
        self.view.backgroundColor = [UIColor clearColor];
    }];
}

@end