//
//  ColorBox.m
//  colors
//
//  Created by Zinets Victor on 10/20/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ColorBox.h"

@implementation ColorBox {
    UIView *_intView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self intInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self intInit];
    }
    return self;
}

- (void)intInit {
    _intView = [[UIView alloc] initWithFrame:self.bounds];
    _intView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_intView];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    CGFloat h, s, b;
    [backgroundColor getHue:&h saturation:&s brightness:&b alpha:nil];
    _hue = (int)(h * 360);
    _saturation = (int)(s * 255);
    _brightness = (int)(b * 255);
    _intView.backgroundColor = backgroundColor;
}

-(void)setHue:(int)hue {
    _hue = hue;
    _intView.backgroundColor = [UIColor colorWithH:_hue S:_saturation B:_brightness];
}

-(void)setBrightness:(int)brightness {
    _brightness = brightness;
    _intView.backgroundColor = [UIColor colorWithH:_hue S:_saturation B:_brightness];
}

-(void)setSaturation:(int)saturation {
    _saturation = saturation;
    _intView.backgroundColor = [UIColor colorWithH:_hue S:_saturation B:_brightness];
}

- (void)setColor:(HSBColor)newColor {
    UIColor *c = [UIColor colorWithHue:newColor.hue / 255. saturation:newColor.saturation / 255. brightness:newColor.brightness / 255. alpha:1];
    self.backgroundColor = c;
}

@end
