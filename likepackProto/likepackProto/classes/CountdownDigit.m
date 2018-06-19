//
// Created by Victor Zinets on 6/19/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import "CountdownDigit.h"

@interface CountdownDigit () {
    CALayer *topLayer, *bottomLayer, *dividerLayer;
    UILabel *label;
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
    _bottomColor = [UIColor brownColor];
    _topColor = [UIColor redColor];
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
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:28];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];

    [self updateDesign];
}

#pragma mark setters -

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

- (void)setNumericValue:(NSInteger)numericValue {
    _numericValue = numericValue;
    label.text = [@(_numericValue) stringValue];
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

@end