//
//  UIColor+HSV.m
//  colors
//
//  Created by Zinets Victor on 10/20/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "UIColor+HSV.h"

@implementation UIColor (HSV)

+ (UIColor *)colorWithH:(int)hue S:(int)saturation B:(int)brightness {
    return [UIColor colorWithHue:hue / 360.0
                      saturation:saturation / 255.0
                      brightness:brightness / 255.0
                           alpha:1.0];
}

@end
