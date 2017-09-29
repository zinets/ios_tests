//
//  ViewController.m
//  testFloatingHeart
//
//  Created by Zinets Viktor on 9/28/17.
//  Copyright © 2017 TogetherN. All rights reserved.
//

#import "ViewController.h"
#import "HeartAnimatedButton.h"

@interface ViewController () {
    HeartAnimatedButton *ownButton;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    HeartAnimatedButton *heartButton = [[HeartAnimatedButton alloc] initWithFrame:(CGRect){20, 120, 38, 38}];
    [heartButton setBackgroundColor:[UIColor lightGrayColor]];

    [heartButton setImage:[UIImage imageNamed:@"streamLikeIcon"]
                 forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"streamLikeIconWhite"]
                 forState:UIControlStateHighlighted];
    [heartButton setImage:[UIImage imageNamed:@"streamLikeIconHighlighted"]
                 forState:UIControlStateSelected];

    [heartButton addTarget:self action:@selector(onHeartTap:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:heartButton];

    ownButton = [[HeartAnimatedButton alloc] initWithFrame:(CGRect){70, 120, 38, 38}];
    [ownButton setBackgroundColor:[UIColor lightGrayColor]];
    ownButton.maxHeightOfRaising = 150;

    [ownButton setImage:[UIImage imageNamed:@"streamLikeIcon"]
            forState:UIControlStateNormal];
    [ownButton setImage:[UIImage imageNamed:@"streamLikeIconWhite"]
            forState:UIControlStateHighlighted];
    [ownButton setImage:[UIImage imageNamed:@"streamLikeIconWhite"]
                 forState:UIControlStateSelected];

    [ownButton addTarget:self action:@selector(onHeartTap:) forControlEvents:UIControlEventTouchUpInside];
    ownButton.tag = 1;
    [self.view addSubview:ownButton];

}

- (void)onHeartTap:(UIButton *)sender {
    if (sender.tag == 1) {
        sender.selected = !sender.selected;
    } else {
        [ownButton addAnimation];
    }
}

@end
