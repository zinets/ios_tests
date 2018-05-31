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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
