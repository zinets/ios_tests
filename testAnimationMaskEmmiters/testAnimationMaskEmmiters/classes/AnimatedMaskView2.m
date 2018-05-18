//
// Created by Victor Zinets on 5/18/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "AnimatedMaskView2.h"
#import "UIImage+Thumbnails.h"

@interface AnimatedMaskView2 ()
@property (nonatomic, strong) CALayer *bwImageLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation AnimatedMaskView2 {

}

- (void)layoutSubviews {
    [super layoutSubviews];

    _maskLayer.frame = self.bounds;
    _bwImageLayer.frame = self.bounds;
}

#pragma mark getters -

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer new];
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
    return _maskLayer;
}

- (CALayer *)bwImageLayer {
    if (!_bwImageLayer) {
        _bwImageLayer = [CALayer new];
        _bwImageLayer.mask = self.maskLayer;

        [self.layer addSublayer:_bwImageLayer];
    }
    return _bwImageLayer;
}

#pragma mark setters -

- (void)setImage:(UIImage *)image {
    [super setImage:image];

    if (self.bwMode) {
        [self addBWLayer];
    }
}

- (void)setBwMode:(BOOL)bwMode {
    _bwMode = bwMode;
    if (_bwMode) {
        [self addBWLayer];
    } else {
        [self animateBWRemoving];
    }
}

#pragma mark -

-(void)addBWLayer {
    self.bwImageLayer.contents = (id)[self.image grayScaleImageWithBgColor:self.backgroundColor].CGImage;
    self.bwImageLayer.contentsGravity = self.layer.contentsGravity;

    _maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

-(void)animateBWRemoving {
    CGFloat w = 10;
    CGFloat h = 10;

    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:self.bounds];
    framePath.usesEvenOddFillRule = YES;

    CGRect startFrame = (CGRect){(self.bounds.size.width - w) / 2, (self.bounds.size.height - h) / 2, w, h};
    CGFloat radii = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startFrame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){radii, radii}];
    [framePath appendPath:startPath];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = .45;

    CABasicAnimation *maskAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation1.duration = animationGroup.duration / 2;
    maskAnimation1.fromValue = (id)framePath.CGPath;

    framePath = [UIBezierPath bezierPathWithRect:self.bounds];
    framePath.usesEvenOddFillRule = YES;
    CGRect finish1Frame = CGRectInset(self.bounds, self.bounds.size.width / 4, self.bounds.size.height / 4);
    UIBezierPath *finish1Path = [UIBezierPath bezierPathWithRoundedRect:finish1Frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){radii, radii}];
    [framePath appendPath:finish1Path];

    maskAnimation1.toValue = (id)framePath.CGPath;
    maskAnimation1.removedOnCompletion = NO;

    CABasicAnimation *maskAnimation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation2.duration = animationGroup.duration / 2;
    maskAnimation2.beginTime = animationGroup.duration / 2;
    maskAnimation2.fromValue = (id)framePath.CGPath;

    framePath = [UIBezierPath bezierPathWithRect:self.bounds];
    framePath.usesEvenOddFillRule = YES;
    CGRect finish2Frame = self.bounds;
    UIBezierPath *finish2Path = [UIBezierPath bezierPathWithRoundedRect:finish2Frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){1, 1}];
    [framePath appendPath:finish2Path];

    maskAnimation2.toValue = (id)framePath.CGPath;

    animationGroup.animations = @[maskAnimation1, maskAnimation2];
    [self.maskLayer addAnimation:animationGroup forKey:@"maskAnimation"];

    self.maskLayer.path = framePath.CGPath;
}

@end