//
//  ViewController.m
//  FrameworksDemoApp
//
//  Created by Zinets Victor on 6/1/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)onTap1:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)onTap2:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
