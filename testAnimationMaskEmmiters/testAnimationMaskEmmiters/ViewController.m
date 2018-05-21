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
#import "FavButton.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet AnimatedMaskView2 *previewImageView;
@property (weak, nonatomic) IBOutlet AnimatedMaskView *i2;
@property (weak, nonatomic) IBOutlet AnimatedMaskView *i3;

@property (weak, nonatomic) IBOutlet FavButton *testFavButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.previewImageView.bwMode = YES;
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
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

#pragma mark button animations -

- (IBAction)onTap:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
        return;
    }
    
    UIImageView *icon = [UIImageView new];
    CGRect frm = [self.view convertRect:sender.imageView.frame fromView:sender];
    icon.image = [sender imageForState:(UIControlStateHighlighted)];
    icon.frame = frm;
    [self.view addSubview:icon];
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [UIView animateWithDuration:0.9 animations:^{
        icon.center = center;
    } completion:^(BOOL finished) {
        [self startParticles:center];
        [icon removeFromSuperview];        
    }];
    sender.selected = YES;
}

- (void)startParticles:(CGPoint)startPoint {
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = startPoint;
    emitterLayer.emitterZPosition = 10.0;
    emitterLayer.emitterSize = CGSizeMake(0, 0);
    emitterLayer.emitterShape = kCAEmitterLayerSphere;
    emitterLayer.spin = 0.5;
    
    CAEmitterCell *emitterCell = [CAEmitterCell emitterCell];
    
    emitterCell.scale = 0.4;
    emitterCell.scaleRange = 0.7;
    
    emitterCell.emissionRange = (CGFloat)M_PI;
    
    emitterCell.lifetime = 10.0;
    emitterCell.birthRate = 4.0;
    emitterCell.velocity = 100.0;
    emitterCell.velocityRange = 100.0;
    
    emitterCell.xAcceleration = 100.0;
    emitterCell.yAcceleration = -20.0;
    
    
    emitterCell.contents = (id)[[UIImage imageNamed:@"favorite2_hlited"] CGImage];
    
    emitterLayer.emitterCells = @[emitterCell];
    [self.view.layer addSublayer:emitterLayer];
}

@end
