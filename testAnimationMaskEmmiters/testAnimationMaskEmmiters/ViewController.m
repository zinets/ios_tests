//
//  ViewController.m
//  testAnimationMaskEmmiters
//
//  Created by Victor Zinets on 5/18/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedMaskView.h"
#import "AnimatedMaskView2.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AnimatedMaskView2 *previewImageView;
@property (weak, nonatomic) IBOutlet AnimatedMaskView *i2;
@property (weak, nonatomic) IBOutlet AnimatedMaskView *i3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.previewImageView.bwMode = YES;
}

- (IBAction)reset:(id)sender {
    self.previewImageView.image = [UIImage imageNamed:@"preview.jpg"];
    self.i2.image = [UIImage imageNamed:@"preview.jpg"];
    self.i3.image = [UIImage imageNamed:@"preview.jpg"];

}

- (IBAction)changeBw:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.previewImageView.bwMode = !sender.selected;
}

- (IBAction)animate:(id)sender {
//    [self.previewImageView animate];
    [self.i2 animate];
    [self.i3 animate];
}

@end
