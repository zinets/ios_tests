//
//  ViewController.m
//  insetsTest
//
//  Created by Zinetz Victor on 29.05.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _testButton.titleLabel.numberOfLines = 0;
    [_testButton setTitle:@"Drop a few lines about yourself and I'll\nanswer any of your questions!"
                 forState:(UIControlStateNormal)];
    
    borderControl(_testButton.imageView);
    borderControl(_testButton.titleLabel);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSliderChanged:(id)sender {
    UISlider * slider = (UISlider *)sender;
    UIEdgeInsets insets = _testButton.imageEdgeInsets;
    switch (slider.tag) {
        case 1:
            insets.top = slider.value;
            break;
        case 2:
            insets.bottom = -slider.value;
            break;
        case 3:
            insets.left = slider.value;
            break;
            
        default:
            insets.right = -slider.value;
            break;
    }
    [_testButton setImageEdgeInsets:insets];
    _values.text = [NSString stringWithFormat:@"%@\n%@", NSStringFromUIEdgeInsets(insets), NSStringFromUIEdgeInsets(_testButton.titleEdgeInsets)];
}

- (IBAction)onTextSliderChanged:(id)sender {
    UISlider * slider = (UISlider *)sender;
    UIEdgeInsets insets = _testButton.titleEdgeInsets;
    switch (slider.tag) {
        case 1:
            insets.top = slider.value;
            break;
        case 2:
            insets.bottom = -slider.value;
            break;
        case 3:
            insets.left = slider.value;
            break;
            
        default:
            insets.right = -slider.value;
            break;
    }
    [_testButton setTitleEdgeInsets:insets];
    _values.text = [NSString stringWithFormat:@"%@\n%@", NSStringFromUIEdgeInsets(_testButton.imageEdgeInsets),                    NSStringFromUIEdgeInsets(insets)];

}

@end
