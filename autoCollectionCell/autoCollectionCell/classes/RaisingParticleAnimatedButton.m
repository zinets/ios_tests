//
// Created by Zinets Viktor on 9/29/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "RaisingParticleAnimatedButton.h"

@interface ActiveHeartLayer : CALayer
@end

@interface RaisingParticleAnimatedButton () {
    CALayer *layerHeart;
    UIImage *highlightedImage;
    UIImage *selectedImage;
}
@end

@implementation RaisingParticleAnimatedButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }

    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
        highlightedImage = [self imageForState:(UIControlStateHighlighted)];
        selectedImage = [self imageForState:(UIControlStateSelected)];
    }
    return self;
}
- (void)commonInit {
    _maxHeightOfRaising = 100;
    _maxNumberOfRaisingElements = 6;
    [self addTarget:self action:@selector(onTapCompleted:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - actions

- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state {
    switch (state) {
        case UIControlStateHighlighted:
            highlightedImage = image;
            [super setImage:image forState:state];
            [super setImage:image forState:UIControlStateSelected];
            break;
        case UIControlStateSelected:
            selectedImage = image;
            break;
        default:
            [super setImage:image forState:state];
            break;
    }
}


- (void)onTapCompleted:(UIControl *)sender {
    if (sender.selected) return;

    [self addAnimation:selectedImage withHighlighting:YES];
}

- (void)addAnimation {
    [self addAnimation:highlightedImage withHighlighting:self.selected];
}

- (void)addAnimation:(UIImage *)activeImage withHighlighting:(BOOL)hliting {
    
    for (int attempt = 0; attempt < _maxNumberOfRaisingElements; attempt++) {
        CGFloat const floatingTime = 2;
        BOOL mirrored = attempt % 2 == 1;
        ActiveHeartLayer *layerActiveHeart = [ActiveHeartLayer layer];
        layerActiveHeart.frame = self.bounds;
        layerActiveHeart.contents = (id)activeImage.CGImage;
        if (mirrored) { // миррорингую - контрол типа универсальный, но делаем конкретно с ладошками и чтоб это были левые и правые ладошки
            layerActiveHeart.doubleSided = YES;
            layerActiveHeart.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
        }
        layerActiveHeart.opacity = 0;
        [self.layer addSublayer:layerActiveHeart];
        
        // 8шаговая много ходов очка
        CAAnimationGroup *ga = [CAAnimationGroup animation];
        ga.beginTime = CACurrentMediaTime() + attempt * 0.5;
        
        ga.duration = floatingTime; {
            CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.keyTimes = @[@0, @(0.05), @(.8), @1];
            opacityAnimation.values =   @[@0, @1,      @1,    @0];
            
            CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.keyTimes = @[@0, @(0.5), @1];
            scaleAnimation.values =   @[@(0.5), @(0.9), @1];
            
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            positionAnimation.keyTimes = @[@0, @(0.1), @(0.25), @1];
            positionAnimation.values =   @[@0, @0,     @(-20),  @(-100)];
            positionAnimation.additive = YES;
            
            CAKeyframeAnimation *positionAnimation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"]; {
                UIBezierPath *path = [UIBezierPath bezierPath];
                CGPoint beginPoint = layerHeart.bounds.origin;
                CGPoint endPoint = (CGPoint) {beginPoint.x, beginPoint.y - _maxHeightOfRaising};
                CGFloat controlSpread = arc4random_uniform(25);
                if (mirrored) { controlSpread = -controlSpread; }
                CGPoint control1 = (CGPoint) {beginPoint.x - controlSpread, beginPoint.y - _maxHeightOfRaising * .25};
                controlSpread = arc4random_uniform(50);
                if (mirrored) { controlSpread = -controlSpread; }
                CGPoint control2 = (CGPoint) {beginPoint.x - controlSpread, beginPoint.y - _maxHeightOfRaising * .75};
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
        
        [ga setValue:layerActiveHeart forKey:@"layer"];
        [layerActiveHeart addAnimation:ga forKey:nil];
    }
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
//        [self removeFromSuperlayer];
        CALayer *layer = [anim valueForKey:@"layer"];
        [layer removeFromSuperlayer];
    }
}

@end
