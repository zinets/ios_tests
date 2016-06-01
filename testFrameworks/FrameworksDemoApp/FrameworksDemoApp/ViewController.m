//
//  ViewController.m
//  FrameworksDemoApp
//
//  Created by Zinets Victor on 6/1/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
@import StaticFramework;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (IBAction)onTap1:(id)sender {
    self.label.text = [StaticLib staticMethod];
}

- (IBAction)onTap2:(id)sender {
    StaticLib *instance = [StaticLib new];
    self.label.text = [instance instanceMethod:35];
}


@end
