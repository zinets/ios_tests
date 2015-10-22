//
//  ViewController.h
//  croppingTest
//
//  Created by Zinetz Victor on 17.01.13.
//  Copyright (c) 2013 Zinetz Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
- (IBAction)onClick:(id)sender;
- (IBAction)onOffsetTest:(id)sender;

@end
