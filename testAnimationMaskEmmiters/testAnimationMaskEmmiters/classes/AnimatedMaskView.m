//
// Created by Victor Zinets on 5/18/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "AnimatedMaskView.h"
#import "UIImage+Thumbnails.h"

@implementation AnimatedMaskView {
    CALayer *colorImage;
    CALayer *bwImage;
    CAShapeLayer *maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    self.clipsToBounds = YES;

    bwImage = [CALayer new];
    [self.layer addSublayer:bwImage];

    colorImage = [CALayer new];
    [self.layer addSublayer:colorImage];

    maskLayer = [CAShapeLayer new];
    colorImage.mask = maskLayer;
    colorImage.masksToBounds = YES;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    colorImage.frame = self.bounds;
    maskLayer.frame = self.bounds;

    bwImage.frame = self.bounds;
}

#pragma mark public -

-(void)reset {
    maskLayer.path = nil;
}

-(void)animate {
    CGFloat w = 10;
    CGFloat h = 10;

    CGRect startFrame = (CGRect){(self.bounds.size.width - w) / 2, (self.bounds.size.height - h) / 2, w, h};
    CGFloat radii = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startFrame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){radii, radii}];

    CGRect finish1Frame = CGRectInset(self.bounds, self.bounds.size.width / 4, self.bounds.size.height / 4);
    UIBezierPath *finish1Path = [UIBezierPath bezierPathWithRoundedRect:finish1Frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){radii, radii}];

    CGRect finish2Frame = self.bounds;
    UIBezierPath *finish2Path = [UIBezierPath bezierPathWithRoundedRect:finish2Frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){1, 1}];

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = .75;

    CABasicAnimation *maskAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation1.duration = animationGroup.duration / 2;
    maskAnimation1.fromValue = (id)startPath.CGPath;
    maskAnimation1.toValue = (id)finish1Path.CGPath;
    maskAnimation1.removedOnCompletion = NO;

    CABasicAnimation *maskAnimation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation2.duration = animationGroup.duration / 2;
    maskAnimation2.beginTime = animationGroup.duration / 2;
    maskAnimation2.fromValue = (id)finish1Path.CGPath;
    maskAnimation2.toValue = (id)finish2Path.CGPath;

    animationGroup.animations = @[maskAnimation1, maskAnimation2];
    [maskLayer addAnimation:animationGroup forKey:@"maskAnimation"];

    maskLayer.path = finish2Path.CGPath;
}

#pragma mark setters -

- (void)setImage:(UIImage *)image {
    _image = image;

    colorImage.contents = (id)_image.CGImage;
    colorImage.contentsGravity = @"resizeAspectFill";

    bwImage.contents = (id)[_image grayScaleImageWithBgColor:self.backgroundColor].CGImage;
    bwImage.contentsGravity = colorImage.contentsGravity;

    [self reset];
}

@end