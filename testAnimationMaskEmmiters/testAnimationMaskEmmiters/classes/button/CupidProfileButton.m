//
//  FavButton.m
//  testAnimationMaskEmmiters
//
//  Created by Victor Zinets on 5/21/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "CupidProfileButton.h"
@interface CupidProfileButton() <CAAnimationDelegate> {
    CAShapeLayer *pulseLayer;
    CALayer *iconLayer;
}
@end

@implementation CupidProfileButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.layer.masksToBounds = NO;
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = NO;
    self.layer.masksToBounds = NO;
    return self;
}

-(void)setSelected:(BOOL)selected {
    [pulseLayer removeFromSuperlayer];
    [iconLayer removeFromSuperlayer];
    
    if (selected) {
        // bg animation
        pulseLayer = [CAShapeLayer layer];
        pulseLayer.frame = [self bounds];
        pulseLayer.fillColor = [self backgroundColorForState:(UIControlStateSelected)].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds];
        pulseLayer.path = path.CGPath;
        [self.layer addSublayer:pulseLayer];
        
        CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transform.delegate = self;
        
        NSMutableArray *values = [NSMutableArray new];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        
        transform.values = values;
        transform.keyTimes = @[@0.0, @0.6, @1.0];
        transform.removedOnCompletion = NO;
        transform.fillMode = kCAFillModeForwards;
        transform.duration = 0.5;
        transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [pulseLayer addAnimation:transform forKey:@"1"];
        
        // icon animation
        iconLayer = [CALayer layer];
        iconLayer.frame = self.bounds;
        UIImage *img = [self imageForState:(UIControlStateSelected)];
        iconLayer.contents = (id)img.CGImage;
        iconLayer.contentsGravity = @"center";
        iconLayer.contentsScale = 2;
        [self.layer addSublayer:iconLayer];
        
        transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        values = [NSMutableArray new];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0., 0., 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        
        transform.values = values;
        transform.keyTimes = @[@0.0, @0.3, @0.8, @1.0];
        transform.removedOnCompletion = NO;
        transform.fillMode = kCAFillModeForwards;
        transform.duration = 0.5;
        transform.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [iconLayer addAnimation:transform forKey:@"1"];
    } else {
        [super setSelected:NO];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {

        [super setSelected:YES];
    }
}

@end
