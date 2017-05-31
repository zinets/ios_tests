//
//  ColorButton.m
//  PHProject
//
//  Created by Arakelyan on 9/12/14.
//  Copyright (c) 2014 Yarra. All rights reserved.
//

#import "ColorButton.h"

@interface ColorButton() {
    UIColor *_colorNormal;
    UIColor *_colorSelected;
    UIColor *_colorHighlighted;
    UIColor *_colorDisabled;
    
    UIColor *_tintColorNormal;
    UIColor *_tintColorSelected;
    UIColor *_tintColorHighlighted;
    UIColor *_tintColorDisabled;
}

@end


@implementation ColorButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // я задаю дефолтный цвет - прозрачный; если кнопка настраивается цветами, то цвета все равно перенастроятся; если картинками, то пофиг на цвета
        // но если используются картинки И цвета, и не установить цвет normal - то после установки скажем hl и возврата в обычное состояние останется highlite цвет, а это совсем не то, что нужно
        [self setBackgroundColor:[UIColor clearColor] forState:(UIControlStateNormal)];
        
        [self addTarget:self action:@selector(onButtonTap:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_backgroundView) {
        if (!_backgroundView.superview) {
            _backgroundView.userInteractionEnabled = NO;
            [self insertSubview:_backgroundView atIndex:0];
        }
        _backgroundView.frame = self.bounds;
    }
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{    
    switch (state) {
        case UIControlStateNormal:
            _colorNormal = color;
            break;
            
        case UIControlStateDisabled:
            _colorDisabled = color;
            break;
            
        case UIControlStateSelected:
            _colorSelected = color;
            break;
            
        case UIControlStateHighlighted:
            _colorHighlighted = color;
            break;
        default:
            break;
    }
    [self updateState];
}

- (UIColor *)backgroundColorForState:(UIControlState)state {
    UIColor *clr = nil;
    switch (state) {
        case UIControlStateNormal:
            clr = _colorNormal;
            break;
            
        case UIControlStateDisabled:
            clr = _colorDisabled;
            break;
            
        case UIControlStateSelected:
            clr = _colorSelected;
            break;
            
        case UIControlStateHighlighted:
            clr = _colorHighlighted;
            break;
        default:
            break;
    }
    return clr;
}

- (void)setTintColor:(UIColor *)color forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            _tintColorNormal = color;
            break;
            
        case UIControlStateDisabled:
            _tintColorDisabled = color;
            break;
            
        case UIControlStateSelected:
            _tintColorSelected = color;
            break;
            
        case UIControlStateHighlighted:
            _tintColorHighlighted = color;
            break;
        default:
            break;
    }
    [self updateState];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateState];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateState];
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateState];
}

- (void)updateState {
    if (!self.enabled) { // если disabled - однозначно все
        if (_colorDisabled) self.backgroundColor = _colorDisabled;
        if (_tintColorDisabled) self.tintColor = _tintColorDisabled;
    } else {
        if (self.highlighted) {
            if (_colorHighlighted) self.backgroundColor = _colorHighlighted;
            if (_tintColorHighlighted) self.tintColor = _tintColorHighlighted;
        } else if (self.selected) {
            if (_colorSelected) self.backgroundColor = _colorSelected;
            if (_tintColorSelected) self.tintColor = _tintColorSelected;
        } else { // normal state
            if (_colorNormal) self.backgroundColor = _colorNormal;
            if (_tintColorNormal) self.tintColor = _tintColorNormal;
        }
    }
}

#pragma mark - action

- (void)onButtonTap:(id)sender {
    if (self.onTapBlock) {
        self.onTapBlock(self);
    }
}

@end

#pragma mark - counted button

@implementation CountedColorButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.count = 0;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = (UIEdgeInsets){0, titleSize.width, 0, 0};

    CGSize imgSize = self.imageView.frame.size;
    self.titleEdgeInsets = (UIEdgeInsets){imgSize.height, -imgSize.width, -imgSize.height, 0};
}

-(void)setCount:(NSInteger)count
{
    _count = count;
    if (_count) {
        [self setTitle:[@(_count) stringValue] forState:(UIControlStateNormal)];
    } else {
        [self setTitle:@"" forState:(UIControlStateNormal)];
    }

    self.enabled = _count > 0;
}

@end
