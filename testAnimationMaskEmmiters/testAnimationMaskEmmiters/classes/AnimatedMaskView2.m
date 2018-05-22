//
// Created by Victor Zinets on 5/18/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "AnimatedMaskView2.h"
#import "UIImage+Thumbnails.h"

@interface AnimatedMaskView2 () <CAAnimationDelegate>
@property (nonatomic, strong) CALayer *bwImageLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation AnimatedMaskView2 {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.startAnimationPoint = (CGPoint){frame.size.width / 2, frame.size.height / 2};
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.startAnimationPoint = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
    }

    return self;
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
        _maskLayer.frame = self.bounds;
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        _maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
    return _maskLayer;
}

- (CALayer *)bwImageLayer {
    if (!_bwImageLayer) {
        _bwImageLayer = [CALayer new];
        _bwImageLayer.frame = self.bounds;
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
        [self animateBWRemoving:self.startAnimationPoint];
    }
}

#pragma mark -

-(void)addBWLayer {
    self.bwImageLayer.contents = (id)[self.image grayScaleImageWithBgColor:self.backgroundColor].CGImage;
    self.bwImageLayer.contentsGravity = self.layer.contentsGravity;

    _maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

-(void)animateBWRemoving:(CGPoint)startPoint {
    CGFloat w = 10;
    CGFloat h = 10;
    
    NSTimeInterval animationDuration = .45;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationDuration;
    
    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:self.bounds];
    framePath.usesEvenOddFillRule = YES;
    
    // 1) весь фрейм - дырочка с размером w x h = дырка в "сером" слое в указанной точке
    CGRect startFrame = (CGRect){startPoint.x - w / 2, startPoint.y - h / 2, w, h};
    CGFloat halfWidth = MIN(startPoint.x, self.bounds.size.width - startPoint.x);
    CGFloat halfHeight = MIN(startPoint.y, self.bounds.size.height - startPoint.y);
    
    CGFloat radii = MIN(halfWidth, halfHeight);
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startFrame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){radii, radii}];
    [framePath appendPath:startPath];
    
    CABasicAnimation *maskAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation1.duration = animationGroup.duration / 2;
    maskAnimation1.fromValue = (id)framePath.CGPath;
    
    framePath = [UIBezierPath bezierPathWithRect:self.bounds];
    framePath.usesEvenOddFillRule = YES;

    // 2) весь фрейм - 1/2 фрейма = "дырочка" в сером слое расширается с скругленными краями
    CGRect finish1Frame = (CGRect){startPoint.x - halfWidth / 2, startPoint.y - halfHeight / 2, halfWidth, halfHeight};
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
    // 3) весь фрейм со скруглением углов в 1 пк = дырка с скругленными краями на пол-фрейма расширяется на весь фрейм с уменьшением скругления
    UIBezierPath *finish2Path = [UIBezierPath bezierPathWithRoundedRect:finish2Frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){1, 1}];
    [framePath appendPath:finish2Path];

    maskAnimation2.toValue = (id)framePath.CGPath;

    animationGroup.animations = @[maskAnimation1, maskAnimation2];
    animationGroup.delegate = self;
    [self.maskLayer addAnimation:animationGroup forKey:@"maskAnimation"];

    self.maskLayer.path = framePath.CGPath;
}

-(void)animateBWRemoving {
    CGFloat w = 10;
    CGFloat h = 10;
    NSTimeInterval animationDuration = 0.45;

    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = animationDuration;

    UIBezierPath *framePath = [UIBezierPath bezierPathWithRect:self.bounds];
    framePath.usesEvenOddFillRule = YES;

    // 1) весь фрейм - дырочка с размером 4*4 = дырка в "сером" слое в центре
    CGRect startFrame = (CGRect){(self.bounds.size.width - w) / 2, (self.bounds.size.height - h) / 2, w, h};
    CGFloat radii = MIN(self.bounds.size.width, self.bounds.size.height) / 2;
    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:startFrame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){radii, radii}];
    [framePath appendPath:startPath];
    
    CABasicAnimation *maskAnimation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    maskAnimation1.duration = animationGroup.duration / 2;
    maskAnimation1.fromValue = (id)framePath.CGPath;

    framePath = [UIBezierPath bezierPathWithRect:self.bounds];
    framePath.usesEvenOddFillRule = YES;
    
    // 2) весь фрейм - 1/2 фрейма = "дырочка" в сером слое расширается с скругленными краями до "половины" фрейма
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
    // 3) весь фрейм со скруглением углов в 1 пк = дырка с скругленными краями на пол-фрейма расширяется на весь фрейм с уменьшением скругления
    UIBezierPath *finish2Path = [UIBezierPath bezierPathWithRoundedRect:finish2Frame byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){1, 1}];
    [framePath appendPath:finish2Path];

    maskAnimation2.toValue = (id)framePath.CGPath;

    animationGroup.animations = @[maskAnimation1, maskAnimation2];
    animationGroup.delegate = self;
    [self.maskLayer addAnimation:animationGroup forKey:@"maskAnimation"];

    self.maskLayer.path = framePath.CGPath;
}

#pragma mark animation delegate -

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [_bwImageLayer removeFromSuperlayer];
        _bwImageLayer = nil;
        _maskLayer = nil;
    }
}

@end
