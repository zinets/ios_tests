//
//  ViewController.m
//  animatedPopup
//
//  Created by Zinets Viktor on 5/30/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "PopupController.h"


@interface ViewController () <UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)onTap:(id)sender {
    PopupController *popup = [PopupController new];
    [self.navigationController pushViewController:popup animated:YES];
}

@end
