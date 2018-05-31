//
//  ViewController.m
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "OnboardingVideoTutorialViewController.h"
#import "VideoUploadMotivationViewController.h"
#import "GradientButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    GradientButton *btn = [GradientButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = (CGRect){20, 120, 190, 60};
    btn.startGradientColor = [UIColor greenColor];
    btn.endGradientColor = [UIColor brownColor];
    btn.cornerRadius = 25;
    [btn setTitle:@"Tap me полность" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self showViewController:[OnboardingVideoTutorialViewController new] sender:self];
}

- (IBAction)onTap2:(id)sender {
    [self showViewController:[VideoUploadMotivationViewController new] sender:self];
}
@end
