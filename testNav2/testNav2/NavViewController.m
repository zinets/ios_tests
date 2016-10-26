//
//  NavViewController.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBarHidden = YES;
}

- (void)menu:(id)sender didSelectItem:(MenuItem)menuItem {
    NSLog(@"!");
}

@end
