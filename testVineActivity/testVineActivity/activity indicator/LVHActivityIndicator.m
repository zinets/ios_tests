//
//  LVHActivityIndicator.m
//  testVineActivity
//
//  Created by Zinets Victor on 4/20/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import "LVHActivityIndicator.h"

@implementation LVHActivityIndicator {
    UIImageView * _vine;
    BOOL isAnimating;
    CATransformLayer * tl;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        
        UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading-bg"]];
        bg.center = (CGPoint){frame.size.width / 2, frame.size.height / 2};
        bg.image = nil;
        bg.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        bg.layer.cornerRadius = 10;
        bg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [self addSubview:bg];
        
        _vine = [[UIImageView alloc] initWithFrame:(CGRect){{0, 0}, {100, 100}}];
        _vine.center = (CGPoint){bg.bounds.size.width / 2, bg.bounds.size.height / 2};
        
        tl = [CATransformLayer layer];
        tl.frame = _vine.bounds;
        
        CALayer * layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:@"loading-icon-back"].CGImage;
        layer.frame = _vine.bounds;
        layer.doubleSided = YES;
        layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
        [tl addSublayer:layer];

        layer = [CALayer layer];
        layer.contents = (id)[UIImage imageNamed:@"loading-icon"].CGImage;
        layer.frame = _vine.bounds;
        layer.doubleSided = YES;
        
        [tl addSublayer:layer];
        
        [_vine.layer addSublayer:tl];
        [bg addSubview:_vine];
    }
    return self;
}

#pragma mark - 

- (void)startAnimating
{
    if (!isAnimating) {
        isAnimating = YES;
        
        CAAnimationGroup * ag = [CAAnimationGroup animation];
        ag.duration = 10;
        ag.repeatCount = HUGE_VALF;
        
        CGFloat duration = 1.5;
        CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        rotationAnimation.fromValue = 0;
        rotationAnimation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        rotationAnimation.duration = duration;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = HUGE_VALF;
        
        CABasicAnimation * rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
        rotationAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        rotationAnimation2.fromValue = 0;
        rotationAnimation2.toValue = [NSNumber numberWithFloat: 2*M_PI];
        rotationAnimation2.duration = 10;
        rotationAnimation2.cumulative = YES;
        rotationAnimation2.repeatCount = HUGE_VALF;
        
        NSArray * arr = @[rotationAnimation, rotationAnimation2];
        ag.animations = arr;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            [tl addAnimation:ag forKey:@"rotationAnimation"];
        }];

    }
}

- (void)stopAnimating
{
    if (isAnimating) {
        isAnimating = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [tl removeAnimationForKey:@"rotationAnimation"];
        }];
    }
}

- (BOOL)isAnimating
{
    return isAnimating;
}

@end
