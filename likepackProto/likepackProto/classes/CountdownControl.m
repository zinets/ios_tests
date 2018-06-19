//
//  CountdownControl.m
//  likepackProto
//
//  Created by Victor Zinets on 6/19/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "CountdownControl.h"

@interface CountdownBlock : UIView <CAAnimationDelegate>
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;
@property (nonatomic, strong) UIColor *dividerColor;
@property (nonatomic) CGFloat cornerRadius;

@property (nonatomic, strong) NSString *stringValue;
@end

@implementation CountdownBlock {
    CALayer *topLayer, *bottomLayer, *dividerLayer;
    CALayer *shapeLayer;
    UILabel *label;
    
    CABasicAnimation *rotation1, *rotation2;
    
    UIImage *topPartNew, *bottomPartNew, *topPartOld, *bottomPartOld;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _bottomColor = [UIColor brownColor];
    _topColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    _dividerColor = [UIColor yellowColor];
    _cornerRadius = 10;

    CGRect frm = self.bounds;
    
    topLayer = [CALayer layer];
    frm.size.height /= 2;
    topLayer.frame = frm;
    [self.layer insertSublayer:topLayer atIndex:0];
    
    bottomLayer = [CALayer layer];
    frm.origin.y = frm.size.height;
    bottomLayer.frame = frm;
    [self.layer insertSublayer:bottomLayer atIndex:0];
    
    dividerLayer = [CALayer layer];
    frm.origin.y -= 0.5;
    frm.size.height = 1;
    dividerLayer.frame = frm;
    [self.layer addSublayer:dividerLayer];
    
    label = [[UILabel alloc] initWithFrame:self.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:28];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    
//    self.stringValue = @"0";
    
//    [self updateDesign];
}

- (void)setTopColor:(UIColor *)topColor {
    _topColor = topColor;
    [self updateDesign];
}

-(void)setBottomColor:(UIColor *)bottomColor {
    _bottomColor = bottomColor;
    [self updateDesign];
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updateDesign];
}

//-(void)setNumericValue:(NSInteger)numericValue {
//    _numericValue = numericValue;
//    label.text = [NSString stringWithFormat:@"%02ld", (long)_numericValue];
//}

-(void)setStringValue:(NSString *)stringValue {
    
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize sz = self.bounds.size;
    sz.height /= 2;
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [snapshot drawAtPoint:(CGPoint){0, 0}];
    topPartOld = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [snapshot drawAtPoint:(CGPoint){0, -sz.height}];
    bottomPartOld = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _stringValue = stringValue;
    label.text = _stringValue;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [snapshot drawAtPoint:(CGPoint){0, 0}];
    topPartNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [snapshot drawAtPoint:(CGPoint){0, -sz.height}];
    bottomPartNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    topLayer.contents = (id)topPartNew.CGImage;
    bottomLayer.contents = (id)bottomPartOld.CGImage;
    
//    label.hidden = YES;
    
    shapeLayer = [CALayer layer];
    shapeLayer.anchorPoint = (CGPoint){0.5, 1};
    shapeLayer.frame = (CGRect){{0, 0}, sz};

    shapeLayer.contents = (id)topPartOld.CGImage;
    shapeLayer.doubleSided = YES;
    
    [self.layer addSublayer:shapeLayer];
    
    rotation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotation1.duration = 4;
    rotation1.removedOnCompletion = NO;
    rotation1.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    CATransform3D transform = CATransform3DMakeRotation(M_PI_2, 1, 0, 0);
    transform.m34 = - 1. / 500.;
    rotation1.toValue = [NSValue valueWithCATransform3D:transform];
    
    shapeLayer.delegate = self;
    [shapeLayer addAnimation:rotation1 forKey:@"a1"];
}

- (void)updateDesign {
    topLayer.backgroundColor = self.topColor.CGColor;
    bottomLayer.backgroundColor = self.bottomColor.CGColor;
    dividerLayer.backgroundColor = self.dividerColor.CGColor;
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = YES;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect frm = self.bounds;
    
    frm.size.height /= 2;
    topLayer.frame = frm;
    
    frm.origin.y = frm.size.height;
    bottomLayer.frame = frm;
    
    frm.origin.y -= 0.5;
    frm.size.height = 1;
    dividerLayer.frame = frm;
}

#pragma mark animation -

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (anim == rotation1) {
        shapeLayer.contents = (id)bottomPartNew.CGImage;
        
        rotation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
        rotation2.duration = 4;
        CATransform3D transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        transform.m34 = - 1. / 500.;
        rotation2.toValue = [NSValue valueWithCATransform3D:transform];
        
        [shapeLayer addAnimation:rotation2 forKey:@"a2"];
    } else if (anim == rotation2) {
        [shapeLayer removeFromSuperlayer];
        shapeLayer = nil;
    }
}

@end

@implementation CountdownControl {
    CountdownBlock *blockMinutes, *blockSeconds;
    UILabel *divider1;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    blockMinutes = [CountdownBlock new];
    [self addSubview:blockMinutes];
    
    blockSeconds = [CountdownBlock new];
//    [self addSubview:blockSeconds];
    
    divider1 = [UILabel new];
    divider1.textAlignment = NSTextAlignmentCenter;
    divider1.font = [UIFont systemFontOfSize:28];
    divider1.textColor = [UIColor whiteColor];
    divider1.text = @":";
    [self addSubview:divider1];
    
    [self relayControls];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)relayControls {
    // хз как делать раскладку; пусть возьмем высоту контрола и это будет размером квадратного блока; и блоки раскладу от left "как получится"
    CGFloat h = self.bounds.size.height;
    CGFloat x = 0;
    CGFloat space = 10;
    
    blockMinutes.frame = (CGRect){x, 0, h, h};
    x += h;
    divider1.frame = (CGRect){x, 0, space, h};
    x += space;
    blockSeconds.frame = (CGRect){x, 0, h, h};
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self relayControls];
}

#pragma mark setters -

-(void)setRemainingTime:(NSTimeInterval)remainingTime {
    
}

-(void)test {
    static NSInteger num = 0;
    
    blockMinutes.stringValue = [@(num) stringValue];
    
    num = (num + 1) % 10;
    
}

@end
