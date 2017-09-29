//
//  ViewController.m
//  testFloatingHeart
//
//  Created by Zinets Viktor on 9/28/17.
//  Copyright © 2017 TogetherN. All rights reserved.
//

#import "ViewController.h"
#import "heart layer/HeartButton.h"

@interface ViewController () {
    CALayer *layerHeart;
    CALayer *layerActiveHeart;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = (CGRect){20, 120, 38, 38};
    [button setBackgroundColor:[UIColor lightGrayColor]];

    [button setImage:[UIImage imageNamed:@"streamLikeIcon"]
            forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"streamLikeIconWhite"]
            forState:UIControlStateHighlighted];

    [button addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];


    [self.view addSubview:button];




    HeartButton *heartButton = [[HeartButton alloc] initWithFrame:(CGRect){70, 120, 38, 38}];
    [heartButton setBackgroundColor:[UIColor lightGrayColor]];

    [heartButton setImage:[UIImage imageNamed:@"streamLikeIcon"]
            forState:UIControlStateNormal];
    [heartButton setImage:[UIImage imageNamed:@"streamLikeIconWhite"]
            forState:UIControlStateHighlighted];

    [heartButton addTarget:self action:@selector(onHeartTap:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:heartButton];

}

- (void)onHeartTap:(UIButton *)sender {
    NSLog(@"!!!");
}

- (void)onTap:(UIButton *)sender {
    if (!layerHeart) {
        layerHeart = [CALayer layer];
        UIImage *heartImage = [UIImage imageNamed:@"streamLikeIconWhite"];
        layerHeart.frame = sender.bounds;
        layerHeart.contents = (id)heartImage.CGImage;
        layerHeart.opacity = 0;
        [sender.layer addSublayer:layerHeart];
    }
    CAKeyframeAnimation *heartDisapearing = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    heartDisapearing.values = @[@1, @1, @0];
    heartDisapearing.keyTimes = @[@0, @(0.9), @1];
    heartDisapearing.duration = 1.;

    [layerHeart addAnimation:heartDisapearing forKey:@"1"];

    if (!layerActiveHeart) {
        layerActiveHeart = [CALayer layer];
        UIImage *image = [UIImage imageNamed:@"streamLikeIconHighlighted"];
        layerActiveHeart.frame = sender.bounds;
        layerActiveHeart.contents = (id)image.CGImage;
        layerActiveHeart.opacity = 0;
        [sender.layer addSublayer:layerActiveHeart];
    }
    // 8шаговая много ходов очка
    CAAnimationGroup *ga = [CAAnimationGroup animation];
    ga.duration = 5.; {
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.keyTimes = @[@0, @(0.05), @(.9), @1];
        opacityAnimation.values =   @[@0, @1,      @1,    @0];

        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.keyTimes = @[@0,      @(0.5), @(0.8), @1];
        scaleAnimation.values =   @[@(0.25), @(0.5), @(0.9), @1];

        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
        positionAnimation.keyTimes = @[@0, @(0.1), @(0.25), @1];
        positionAnimation.values =   @[@0, @0,     @(-20),  @(-100)];
        positionAnimation.additive = YES;

        ga.animations = @[
                opacityAnimation,
                scaleAnimation,
                positionAnimation,
        ];
    }

    [layerActiveHeart addAnimation:ga forKey:@"2"];
}

@end
