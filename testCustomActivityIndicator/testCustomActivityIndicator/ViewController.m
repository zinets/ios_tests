//
//  ViewController.m
//  testCustomActivityIndicator
//
//  Created by Zinets Victor on 6/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "FiveStarsActivityIndicator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet FiveStarsActivityIndicator *activityIndicator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)onStageTap:(UIButton *)sender {
    [self.activityIndicator setStage:sender.tag];
}


@end
