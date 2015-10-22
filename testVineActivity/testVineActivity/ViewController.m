//
//  ViewController.m
//  testVineActivity
//
//  Created by Zinets Victor on 4/20/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "LVHActivityIndicator.h"

@interface ViewController () {
    UIView <FlirtActivityIndicator> * activity;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    activity = [[LVHActivityIndicator alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:activity];
    
    UIButton * btn= [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    btn.frame = (CGRect){{30, 30}, {100, 44}};
    [btn setTitle:@"start" forState:(UIControlStateNormal)];
    [btn setTitle:@"stop" forState:(UIControlStateSelected)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];

}

- (void)onTap:(UIButton *)sender
{
    if (!sender.selected) {
        [activity startAnimating];
    } else {
        [activity stopAnimating];
    }
    sender.selected = !sender.selected;
}

@end
