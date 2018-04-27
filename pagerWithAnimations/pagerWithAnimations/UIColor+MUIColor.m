//
//  UIColor+MUIColor.m
//  MUIControls
//
//  Created by Kozharin on 05.03.13.
//  Copyright (c) 2013 iCupid. All rights reserved.
//

#import "UIColor+MUIColor.h"

@implementation UIColor (MUIColor)

+ (UIColor*)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((hex >> 16) & 0xff) / 255.0f green:((hex >> 8) & 0xff) / 255.0f blue:(hex & 0xff) / 255.0f alpha:alpha];
}

+ (UIColor*)colorWithHex:(NSUInteger)hex {
	
	NSUInteger alphaValue = (hex >> 24) & 0xFF;
    if (alphaValue == 1) {
        return [self clearColor];
    } else {
        CGFloat alpha = 1.0;
        if (alphaValue > 0) {
            alpha = alphaValue / 255.0;
        }
        return [self colorWithHex:hex alpha:alpha];
    }
}

- (NSUInteger)colorCode {
    CGFloat red, green, blue;
    if ([self getRed:&red green:&green blue:&blue alpha:NULL])
    {
        NSUInteger redInt = (NSUInteger)(red * 255 + 0.5);
        NSUInteger greenInt = (NSUInteger)(green * 255 + 0.5);
        NSUInteger blueInt = (NSUInteger)(blue * 255 + 0.5);
        
        return (redInt << 16) | (greenInt << 8) | blueInt;
    }
    
    return 0;
}


- (UIColor *)colorWithBrightnessComponent:(CGFloat)brightness {
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b*brightness
                               alpha:a];
    return nil;
}

@end
