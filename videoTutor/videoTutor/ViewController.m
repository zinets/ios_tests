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

@interface ViewController () <VideoTutorialViewControllerDelegate>

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
    OnboardingVideoTutorialViewController *ctrl = [OnboardingVideoTutorialViewController new];
    ctrl.delegate = self;
    [self showViewController:ctrl sender:self];
}

- (IBAction)onTap2:(id)sender {
    VideoUploadMotivationViewController *ctrl = [VideoUploadMotivationViewController new];
    ctrl.delegate = self;
    [self showViewController:ctrl sender:self];
}

- (void)videoTutorial:(UIViewController *)sender didSelectAction:(VideoTutorialAction)action {
    switch (action) {
        case VideoTutorialActionDoAction:
            NSLog(@"upload video action");
        default:
            [sender dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

@end
