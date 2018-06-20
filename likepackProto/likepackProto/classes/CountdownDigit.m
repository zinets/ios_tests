//
// Created by Victor Zinets on 6/19/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import "CountdownDigit.h"
#import "UIColor+MUIColor.h"

typedef enum {
    MovePhase0,
    MovePhase1,
    MovePhase2,
} MovePhase;

@interface CountdownDigit () <CAAnimationDelegate> {
    CALayer *topLayer, *bottomLayer, *dividerLayer;
    UILabel *label;
    UIImageView *movingPart, *oldBottomPart;
    UIImage *newBottomPart;
    MovePhase movePhase;
}
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;
@property (nonatomic, strong) UIColor *dividerColor;
@property (nonatomic) CGFloat cornerRadius;
@end

@implementation CountdownDigit {

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
    _bottomColor = [UIColor colorWithHex:0x31A5EA];
    _topColor = [UIColor colorWithHex:0x53BAFE];
    _dividerColor = [UIColor colorWithHex:0xB9E5FF];
    _cornerRadius = 10;
    _animationDuration = .5;

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
    frm.size.height = .5;
    dividerLayer.frame = frm;
    [self.layer addSublayer:dividerLayer];

    label = [[UILabel alloc] initWithFrame:self.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:28];
    label.textColor = [UIColor whiteColor];
    label.text = @"0";
    [self addSubview:label];

    [self updateDesign];
}

#pragma mark setters -

- (void)setFont:(UIFont *)font {
    _font = font;
    label.font = _font;
}

- (void)setFontColor:(UIColor *)fontColor {
    _fontColor = fontColor;
    label.textColor = _fontColor;
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

- (void)updateDesign {
    topLayer.backgroundColor = self.topColor.CGColor;
    bottomLayer.backgroundColor = self.bottomColor.CGColor;
    dividerLayer.backgroundColor = self.dividerColor.CGColor;

    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = YES;
}

#pragma mark overrides -

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


- (void)setNumericValue:(NSInteger)numericValue {
    if (numericValue == _numericValue)
        return;

    movePhase = MovePhase1;

    [oldBottomPart removeFromSuperview];
    [movingPart removeFromSuperview];

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotBeforeUpdate = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGSize sz = self.bounds.size;
    sz.height /= 2;
    UIImage *image;

    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [snapshotBeforeUpdate drawAtPoint:(CGPoint){0, 0}];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _numericValue = numericValue;
    label.text = [@(_numericValue) stringValue];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotAfterUpdate = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    movingPart = [[UIImageView alloc] initWithImage:image];
    [self addSubview:movingPart];

    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    [snapshotBeforeUpdate drawAtPoint:(CGPoint){0, -sz.height}];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    oldBottomPart = [[UIImageView alloc] initWithImage:image];
    oldBottomPart.frame = (CGRect){{0, sz.height}, sz};
    [self addSubview:oldBottomPart];

    UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, image.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    
    [snapshotAfterUpdate drawAtPoint:(CGPoint){0, -sz.height}];
    newBottomPart = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self setAnchorPoint:(CGPoint){0.5, 1} forView:movingPart];

    CALayer *layer1 = movingPart.layer;
    layer1.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    layer1.shadowOpacity = 1;
    layer1.shadowRadius = 4;
    layer1.shadowOffset = (CGSize){0, -3};


    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D transform = CATransform3DMakeRotation(-M_PI_2, 1, 0, 0);
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = self.animationDuration / 2;
    animation.delegate = self;

    [layer1 addAnimation:animation forKey:@"a1"];
    layer1.transform = transform;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);

    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);

    CGPoint position = view.layer.position;
    position.x -= oldPoint.x;
    position.x += newPoint.x;

    position.y -= oldPoint.y;
    position.y += newPoint.y;

    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

#pragma mark animation -

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        switch (movePhase) {
            case MovePhase0:
                movePhase = MovePhase1;
                break;
            case MovePhase1: {
                movingPart.image = newBottomPart;
                CALayer *layer1 = movingPart.layer;

                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
                CATransform3D transform = CATransform3DMakeRotation(-M_PI, 1, 0, 0);
                animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_2, 1, 0, 0)];
                animation.toValue = [NSValue valueWithCATransform3D:transform];
                animation.duration = self.animationDuration / 2;

                animation.delegate = self;

                [layer1 addAnimation:animation forKey:@"a2"];
                layer1.transform = transform;

                movePhase = MovePhase2;
                break;
            }
            case MovePhase2:
                [oldBottomPart removeFromSuperview];
                [movingPart removeFromSuperview];

                movePhase = MovePhase0;
                break;
        }
    }
}

@end
