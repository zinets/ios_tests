//
// Created by Zinets Viktor on 9/29/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "HeartAnimatedButton.h"

@interface ActiveHeartLayer : CALayer
@end

@interface HeartAnimatedButton () {
    CALayer *layerHeart;
    UIImage *highlightedImage;
    UIImage *selectedImage;
}
@end

@implementation HeartAnimatedButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _maxHeightOfRaising = 100;
        [self addTarget:self action:@selector(onTapCompleted:) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

#pragma mark - actions

- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state {
    switch (state) {
        case UIControlStateHighlighted:
            highlightedImage = image;
            break;
        case UIControlStateSelected:
            selectedImage = image;
            break;
        default:
            break;
    }
    [super setImage:image forState:state];
}


- (void)onTapCompleted:(UIControl *)sender {
    if (sender.selected) return;

    [self addAnimation];
}

- (void)addAnimation {
    if (!layerHeart) {
        layerHeart = [CALayer layer];
        UIImage *heartImage = highlightedImage;
        layerHeart.frame = self.bounds;
        layerHeart.contents = (id)heartImage.CGImage;
        layerHeart.opacity = 0;
        [self.layer addSublayer:layerHeart];
    }
    CAKeyframeAnimation *heartDisapearing = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    heartDisapearing.values = @[@1, @1, @0];
    heartDisapearing.keyTimes = @[@0, @(0.9), @1];
    heartDisapearing.duration = 1.;

    [layerHeart addAnimation:heartDisapearing forKey:@"1"];

    ActiveHeartLayer *layerActiveHeart = [ActiveHeartLayer layer];
    UIImage *image = selectedImage;
    layerActiveHeart.frame = self.bounds;
    layerActiveHeart.contents = (id)image.CGImage;
    layerActiveHeart.opacity = 0;
    [self.layer addSublayer:layerActiveHeart];

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

        CAKeyframeAnimation *positionAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"]; {
            UIBezierPath *path = [UIBezierPath bezierPath];
            CGPoint beginPoint = layerHeart.bounds.origin;
            CGPoint endPoint = (CGPoint) {beginPoint.x, beginPoint.y - _maxHeightOfRaising};
            CGFloat controlSpread = arc4random_uniform(50);
            CGPoint control1 = (CGPoint) {beginPoint.x + (controlSpread - 25), beginPoint.y - _maxHeightOfRaising * .25};
            controlSpread = arc4random_uniform(100);
            CGPoint control2 = (CGPoint) {beginPoint.x + (controlSpread - 50), beginPoint.y - _maxHeightOfRaising * .75};
            [path moveToPoint:beginPoint];
            [path addCurveToPoint:endPoint controlPoint1:control1 controlPoint2:control2];

            positionAnimation2.path = path.CGPath;
        }
        positionAnimation2.additive = YES;
        positionAnimation2.calculationMode = kCAAnimationPaced;

        ga.animations = @[
                opacityAnimation,
                scaleAnimation,
                positionAnimation2,
        ];
    }

    [layerActiveHeart addAnimation:ga forKey:@"2"];
}

@end

#pragma mark - active layer

@interface ActiveHeartLayer () <CAAnimationDelegate>

@end

@implementation ActiveHeartLayer {

}

- (void)addAnimation:(CAAnimation *)anim forKey:(nullable NSString *)key {
    anim.delegate = self;
    [super addAnimation:anim forKey:key];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self removeFromSuperlayer];
    }
}

@end