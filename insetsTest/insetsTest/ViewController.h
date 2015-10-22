//
//  ViewController.h
//  insetsTest
//
//  Created by Zinetz Victor on 29.05.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *values;
@property (weak, nonatomic) IBOutlet UIButton *testButton;


- (IBAction)onSliderChanged:(id)sender;
- (IBAction)onTextSliderChanged:(id)sender;

@end
