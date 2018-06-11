//
//  ViewController2.m
//  yaScroller
//
//  Created by Victor Zinets on 6/8/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController2.h"
@import TNURLImageView;

@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet TNImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;


@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.contentModeAnimationDuration = 0.3;
}

- (IBAction)loadt1:(id)sender {
    self.imageView.image = [UIImage imageNamed:@"t1"];
}

- (IBAction)loadt2:(id)sender {
    self.imageView.image = [UIImage imageNamed:@"t2"];
}
- (IBAction)loadt3:(id)sender {
       self.imageView.image = [UIImage imageNamed:@"t3"];
}

- (IBAction)onLoadUrl:(id)sender {
    [self.imageView loadImageFromUrl:@"https://i.ytimg.com/vi/KvizWcoqjtw/maxresdefault.jpg"];
}

- (IBAction)onFit:(id)sender {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)onFill2:(id)sender {
    self.imageView.contentMode = UIViewContentModeScaleToFill;
}

- (IBAction)onSize:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        if (sender.selected) {
            self.imageViewHeight.constant = 200;
        } else {
            self.imageViewHeight.constant = 400;
        }
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onFill:(id)sender {
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (IBAction)oncenter:(id)sender {
    self.imageView.contentMode = UIViewContentModeCenter;
}

@end
