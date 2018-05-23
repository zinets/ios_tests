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
#import "LottieAnimatedButton.h"
#import "UIColor+MUIColor.h"

#import <Lottie/Lottie.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AnimatedMaskView2 *previewImageView;
@property (weak, nonatomic) IBOutlet AnimatedMaskView2 *i3;

@property (weak, nonatomic) IBOutlet UIImageView *favoriteMark;


@property (weak, nonatomic) IBOutlet LottieAnimatedButton *testFavButton;
@property (weak, nonatomic) IBOutlet LottieAnimatedButton *testBtn2;
@property (weak, nonatomic) IBOutlet UIView *animationSite;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.previewImageView.bwMode = YES;
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.testFavButton setBackgroundColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.testFavButton setBackgroundColor:[UIColor colorWithHex:0xff8600] forState:(UIControlStateSelected)];
    
    [self.testBtn2 setBackgroundColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.testBtn2 setBackgroundColor:[UIColor colorWithHex:0x983dda] forState:(UIControlStateSelected)];


    self.i3.bwMode = YES;
    self.i3.bwChangingStyle = BWChangeStyleScale;

}

- (IBAction)doubleTap:(UITapGestureRecognizer *)sender {
    __weak typeof(self) weakSelf = self;
    if (self.i3.bwMode) {
        CGRect frm = (CGRect){0, 0, 80, 80};
        LOTAnimationView *animationView = [LOTAnimationView animationNamed:@"80-80"];
        animationView.frame = frm;
        
        UIView *wnd = [UIApplication sharedApplication].keyWindow;
        animationView.center = [wnd convertPoint:self.favoriteMark.center fromView:self.view];
        [wnd addSubview:animationView];

        NSTimeInterval duration = animationView.sceneModel.timeDuration / 2;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.favoriteMark.highlighted = self.i3.bwMode;
        });

        [animationView playWithCompletion:^(BOOL animationFinished) {
            [animationView removeFromSuperview];

            weakSelf.i3.bwMode = !self.i3.bwMode;
        }];
    } else {
        self.i3.bwMode = !self.i3.bwMode;
        self.favoriteMark.highlighted = !self.i3.bwMode;
    }
}

- (IBAction)reset:(id)sender {
    self.previewImageView.image = [UIImage imageNamed:@"preview.jpg"];
    self.i3.image = [UIImage imageNamed:@"preview.jpg"];

}

- (IBAction)changeBw:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.previewImageView.bwMode = !sender.selected;
}

- (IBAction)animate:(id)sender {
//    [self.previewImageView animate];

}

#pragma mark button animations -

- (IBAction)onFavTap:(LottieAnimatedButton *)sender {
    if (sender.selected) {
        self.previewImageView.bwMode = YES;
        self.testFavButton.selected = NO;
    } else {
        CGPoint center = self.previewImageView.center;
        __weak typeof(self) weakSelf = self;
        [sender setSelectedUsingAnimation:^{
            weakSelf.previewImageView.bwMode = NO;
            
            LOTAnimationView *animation = [LOTAnimationView animationNamed:@"boom-favorites"];
            animation.frame = weakSelf.animationSite.bounds;
            [weakSelf.animationSite addSubview:animation];
            [animation playWithCompletion:^(BOOL animationFinished) {
                [animation removeFromSuperview];
                weakSelf.testFavButton.selected = YES;
            }];
        } atFinishPoint:center];
    }
}

- (IBAction)onTap:(LottieAnimatedButton *)sender {
    if (sender.selected) {
        self.previewImageView.bwMode = YES;
        self.testBtn2.selected = NO;
    } else {
        CGPoint center = self.i3.center;

        __weak typeof(self) weakSelf = self;
        [sender setSelectedUsingAnimation:^{
            weakSelf.i3.bwMode = NO;

            LOTAnimationView *animation = [LOTAnimationView animationNamed:@"boom-wink"];
            animation.frame = weakSelf.i3.bounds;
            [weakSelf.i3 addSubview:animation];
            [animation playWithCompletion:^(BOOL animationFinished) {
                [animation removeFromSuperview];
                weakSelf.testBtn2.selected = YES;
            }];
        } atFinishPoint:center];
    }
}

- (void)startParticles:(CGPoint)startPoint tag:(NSInteger)tag {
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = startPoint;
    emitterLayer.emitterZPosition = 10.0;
    emitterLayer.emitterSize = CGSizeMake(0, 0);
    emitterLayer.emitterShape = kCAEmitterLayerCircle;
    emitterLayer.spin = 0.5;
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    
    emitterCell.scale = 0.4;
    emitterCell.scaleRange = 0.7;
    emitterCell.spin = 2 * (arc4random() % 2 == 0 ? 1 : -1);
    emitterCell.spinRange = 0;
    
    emitterCell.emissionRange = (CGFloat)2 * M_PI;
    
    emitterCell.lifetime = 10.0;
    emitterCell.birthRate = 4.0;
    emitterCell.velocity = 100.0;
    emitterCell.velocityRange = 100.0;
    
    emitterCell.xAcceleration = tag == 1 ? 100.0 : -100.0;
    emitterCell.yAcceleration = tag == -20;
    
    
    emitterCell.contents = (id)[[UIImage imageNamed:tag == 1 ? @"favorite2_hlited" : @"winkIcon_hlited"] CGImage];
    
    emitterLayer.emitterCells = @[emitterCell];
    [self.view.layer addSublayer:emitterLayer];
}

- (IBAction)lottieTest:(id)sender {
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"giftbox"];
    animation.frame = self.animationSite.bounds;
    [self.animationSite addSubview:animation];
    [animation playWithCompletion:^(BOOL animationFinished) {
        [animation removeFromSuperview];
    }];
}

@end
