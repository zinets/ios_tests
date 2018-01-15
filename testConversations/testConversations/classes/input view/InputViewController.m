//
//  InputViewController.m
//  testConversations
//
//  Created by Zinets Viktor on 1/12/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label123.text = @"иди в жопу";
}

- (IBAction)onOn:(id)sender {
    
}

- (IBAction)onOff:(id)sender {
    [self.view endEditing:YES];
}

@end
