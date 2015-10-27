//
//  ViewController.m
//  buttons
//
//  Created by Zinets Victor on 10/27/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "DynamicButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    DynamicButton *btn = [[DynamicButton alloc] initWithStyle:(ButtonStyleHamburger)];
    btn.origin = (CGPoint){20, 120};
    [self.view addSubview:btn];
}

@end
