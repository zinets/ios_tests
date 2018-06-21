//
//  CountdownControl.m
//  likepackProto
//
//  Created by Victor Zinets on 6/19/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "CountdownControl.h"
#import "CountdownDigit.h"

@implementation CountdownControl {
    UILabel *divider1;
    CountdownDigit *boxS1, *boxS2, *boxM1, *boxM2;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];

    boxS1 = [CountdownDigit new];
    [self addSubview:boxS1];
    boxS2 = [CountdownDigit new];
    [self addSubview:boxS2];
    boxM1 = [CountdownDigit new];
    [self addSubview:boxM1];
    boxM2 = [CountdownDigit new];
    [self addSubview:boxM2];

    divider1 = [UILabel new];
    divider1.textAlignment = NSTextAlignmentCenter;
    divider1.font = [UIFont systemFontOfSize:28];
    divider1.textColor = [UIColor whiteColor];
    divider1.text = @":";
    [self addSubview:divider1];

    self.digitFont = [UIFont systemFontOfSize:38 weight:UIFontWeightHeavy];
    
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
    // хз как делать раскладку; пусть возьмем высоту контрола и это будет размером "цыфры"; ширина цыфры - как 4:3
    CGFloat const h = self.bounds.size.height;
    CGFloat const w = 0.75f * h;
    CGFloat x = 0;
    CGFloat const space = 20;
    CGFloat const smallSpace = 2;

    boxM1.frame = (CGRect){x, 0, w, h};
    x += w + smallSpace;
    boxM2.frame = (CGRect){x, 0, w, h};
    x += w;
    divider1.frame = (CGRect){x, 0, space, h};
    x += space;
    boxS1.frame = (CGRect){x, 0, w, h};
    x += w + smallSpace;
    boxS2.frame = (CGRect){x, 0, w, h};
    
    [self invalidateIntrinsicContentSize];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self relayControls];
}

-(CGSize)intrinsicContentSize {
    CGSize sz = (CGSize){boxS2.frame.origin.x + boxS2.frame.size.width, boxS2.frame.origin.y + boxS2.frame.size.height};
    
    return sz;
}

#pragma mark setters -

-(void)setRemainingTime:(NSTimeInterval)remainingTime {
    _remainingTime = MAX(0, remainingTime);

    // это секунды; значит делим и вычисляем..
    NSInteger minutes = (int)_remainingTime / 60;
    NSInteger seconds = (int)_remainingTime % 60;

    boxM1.numericValue = minutes / 10;
    boxM2.numericValue = minutes % 10;
    boxS1.numericValue = seconds / 10;
    boxS2.numericValue = seconds % 10;
}

- (void)setDigitFont:(UIFont *)font {
    _digitFont = font;
    boxS1.font = _digitFont;
    boxS2.font = _digitFont;
    boxM1.font = _digitFont;
    boxM2.font = _digitFont;
    divider1.font = _digitFont;
}

- (void)setDigitColor:(UIColor *)fontColor {
    _digitColor = fontColor;
    boxS1.fontColor = _digitColor;
    boxS2.fontColor = _digitColor;
    boxM1.fontColor = _digitColor;
    boxM2.fontColor = _digitColor;
    divider1.textColor = _digitColor;
}

-(void)setAngle:(CGFloat)angle {
    _angle = angle;
    CGAffineTransform transform = _angle == 0 ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(_angle);
    self.transform = transform;
}

@end
