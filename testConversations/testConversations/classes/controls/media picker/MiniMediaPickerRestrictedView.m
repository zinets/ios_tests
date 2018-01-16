//
//  MiniMediaPickerRestrictedView.m
//  testConversations
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "MiniMediaPickerRestrictedView.h"
#import "GradientPanel.h"

@interface MiniMediaPickerRestrictedView ()
@property (weak, nonatomic) IBOutlet GradientPanel *topGradientPanel;

@end

@implementation MiniMediaPickerRestrictedView

-(void)commonInit {
    [super commonInit];
    
    self.topGradientPanel.colors = @[
                                     [UIColor redColor],
                                     [UIColor blueColor],
                                     ];
}

- (IBAction)onSettingsTap:(id)sender {
    NSLog(@"show settings");
}

@end
