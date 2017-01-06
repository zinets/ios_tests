//
//  ViewController.m
//  gradProgress
//
//  Created by Zinets Victor on 1/5/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "ProgressBlock.h"
#import "UIColor+MUIColor.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ProgressBlock *testProgressBlock;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (IBAction)onChange:(UISlider *)sender {
    self.testProgressBlock.progress = sender.value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testProgressBlock.startColor = [UIColor colorWithHex:0x82ca00];
    self.testProgressBlock.endColor = [UIColor colorWithHex:0x0098e7];
    self.testProgressBlock.inactiveColor = [UIColor colorWithHex:0xeceff1];
}

-(void)viewDidAppear:(BOOL)animated {
    self.testProgressBlock.progress = self.slider.value;
}


@end
