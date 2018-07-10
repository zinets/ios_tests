//
//  ViewController.m
//  2circlesLoader
//
//  Created by Victor Zinets on 7/10/18.
//  Copyright © 2018 Dolboyob Inc. All rights reserved.
//

#import "ViewController.h"
#import "TwoCirclesActivityIndicator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TwoCirclesActivityIndicator *activity1;
@property (weak, nonatomic) IBOutlet TwoCirclesActivityIndicator *activity2;
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

- (IBAction)startAnimation:(id)sender {
    [self.activity1 startAnimation];
    [self.activity2 startAnimation];
}

- (IBAction)stopAnimation:(id)sender {
    [self.activity1 stopAnimation];
    [self.activity2 stopAnimation];
}

@end
