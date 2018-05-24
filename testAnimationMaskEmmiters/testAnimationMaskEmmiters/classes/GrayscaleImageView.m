//
//  GrayscaleImageView.m
//  testAnimationMaskEmmiters
//
//  Created by Victor Zinets on 5/24/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "GrayscaleImageView.h"

@interface GrayscaleImageView () <CAAnimationDelegate>
@property (nonatomic, strong) CALayer *bwImageLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation GrayscaleImageView

- (void)commonInit {
    self.startAnimationPoint = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
//    self.bwChangingStyle = BWChangeStyleScale;
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
    // этот метод при загрузке loadFrom... вызывается уже после получения картинки (+ возможно какого-то ресайза), т.е. отдельно перегружать loadFrom.. не нужно; если нужна ч/б, то в создании слоя будет запрошен ч/б вариант картинки, картинка уже готова и в кеше (ну я так думаю. что после скачивания она сразу покладется в кеш?)
    
    if (self.bwMode) {
        [self addBWLayer];
    }
}

- (void)setBwMode:(BOOL)bwMode {
    _bwMode = bwMode;
    if (_bwMode) {
        [self addBWLayer];
    } else {
        switch (self.bwChangingStyle) {
            case BWChangeStyleScale:
                [self animateBWRemoving:self.startAnimationPoint];
                break;
            case BWChangeStyleFade:
                [self animateBWRemovingWithFade];
                break;
        }
    }
}

#pragma mark -

-(void)addBWLayer {
    __weak typeof(self) weakSelf = self;
    [self getImageWithType:ImageTypeGrayscale onImageLoaded:^(UIImage *image) {
        UIImage *grayscaleImage = image;
        weakSelf.bwImageLayer.contents = (id)grayscaleImage.CGImage;
        weakSelf.bwImageLayer.contentsGravity = self.layer.contentsGravity;

        weakSelf.maskLayer.path = [UIBezierPath bezierPathWithRect:weakSelf.bounds].CGPath;
    }];
}

-(void)animateBWRemovingWithFade {
    NSTimeInterval animationDuration = .45;
    
    CABasicAnimation *fadeAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation1.duration = animationDuration;
    fadeAnimation1.fromValue = @1;
    fadeAnimation1.toValue = @0;
    
    fadeAnimation1.delegate = self;
    [self.bwImageLayer addAnimation:fadeAnimation1 forKey:@"fade"];
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

#pragma mark animation delegate -

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [_bwImageLayer removeFromSuperlayer];
        _bwImageLayer = nil;
        _maskLayer = nil;
    }
}

@end
