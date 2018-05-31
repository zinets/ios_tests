//
//  VideoTutorialViewController.m
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "BaseVideoTutorialViewController.h"
#import "VideoBackgroundView.h"
#import "GradientButton.h"

@interface BaseVideoTutorialViewController ()
@property (weak, nonatomic) IBOutlet VideoBackgroundView *backgroundVideoView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet GradientButton *actionButton;

@end

@implementation BaseVideoTutorialViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    return [super initWithNibName:@"BaseVideoTutorialViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoImage.hidden = !self.logoVisible;
    self.titleLabel.text = self.titleText;
    self.descriptionLabel.text = self.descriptionText;
    [self.actionButton setTitle:self.buttonTitleText forState:(UIControlStateNormal)];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.backgroundVideoView play];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundVideoView.media = self.mediaFileName;;
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.backgroundVideoView stop];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onActionTap:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark overrides -

-(NSString *)mediaFileName {
    return nil;
}

-(BOOL)logoVisible {
    return NO;
}

-(NSString *)titleText {
    return nil;
}

-(NSString *)descriptionText {
    return nil;
}

-(NSString *)buttonTitleText {
    return nil;
}

@end
