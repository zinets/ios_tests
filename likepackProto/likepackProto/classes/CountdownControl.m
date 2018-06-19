//
//  CountdownControl.m
//  likepackProto
//
//  Created by Victor Zinets on 6/19/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "CountdownControl.h"

@interface CountdownBlock : UIView
@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;
@property (nonatomic) CGFloat cornerRadius;

@property (nonatomic, strong) NSString *stringValue;
@end

@implementation CountdownBlock {
    CALayer *topLayer, *bottomLayer;
    UILabel *label;
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
    
    label = [[UILabel alloc] initWithFrame:self.bounds];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:28];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    
    self.stringValue = @"3";
    
    [self updateDesign];
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
    _stringValue = stringValue;
    label.text = _stringValue;
}

- (void)updateDesign {
    topLayer.backgroundColor = self.topColor.CGColor;
    bottomLayer.backgroundColor = self.bottomColor.CGColor;
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
    [self addSubview:blockSeconds];
    
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
