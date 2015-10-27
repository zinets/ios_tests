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

    DynamicButton *btn = [[DynamicButton alloc] initWithStyle:(ButtonStyleArrowLeft)];
    btn.origin = (CGPoint){20, 120};
    [btn addTarget:self action:@selector(onTap:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)onTap:(DynamicButton *)sender {
    if (sender.buttonStyle != ButtonStyleHamburger) {
        [sender setButtonStyle:ButtonStyleHamburger animated:YES];
    } else {
        [sender setButtonStyle:ButtonStyleArrowLeft animated:YES];        
    }
}

@end
