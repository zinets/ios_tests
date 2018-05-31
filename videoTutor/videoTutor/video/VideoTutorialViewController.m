//
//  VideoTutorialViewController.m
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "VideoTutorialViewController.h"
#import "VideoBackgroundView.h"

@interface VideoTutorialViewController ()
@property (weak, nonatomic) IBOutlet VideoBackgroundView *backgroundVideoView;
@end

@implementation VideoTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.backgroundVideoView play];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundVideoView.media = @"Untitled.mov";
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.backgroundVideoView stop];
}

- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
