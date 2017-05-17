//
//  ViewController.m
//  videPlayback
//
//  Created by Zinets Viktor on 5/16/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "videoCell.h"

NSString *video1 = @"https://cdn.wdrimg.com/video/slideshow/id/675cb1d57f5d4c4fbc5ddcc6e301a7c8";

NSString *video2 = @"https://cdn.wdrimg.com/video/show/id/675cb1d57f5d4c4fbc5ddcc6e301a7c8";
NSString *preview2 = @"https://cdn.wdrimg.com/video/preview/id/675cb1d57f5d4c4fbc5ddcc6e301a7c8";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet VideoCell *videoCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.videoCell.autostart = YES;
}

- (IBAction)openVideo:(id)sender {
    [self.videoCell loadVideo:video2 preview:preview2];
}

- (IBAction)playVideo:(UIButton *)sender {
    sender.selected = [self.videoCell pause];
}

@end
