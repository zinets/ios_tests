//
//  UIColor+MUIColor.h
//  MUIControls
//
//  Created by Kozharin on 05.03.13.
//  Copyright (c) 2013 iCupid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MUIColor)

+ (UIColor*)colorWithHex:(NSUInteger)hex __attribute__((warn_unused_result));
+ (UIColor*)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha __attribute__((warn_unused_result));

- (NSUInteger)colorCode __attribute__((warn_unused_result));

/*!
 * @discussion Creates and returns a color object using the specified opacity and HSB color space component values.
 * @param brightness (or value) component of the color object in the HSB color space, specified as a value from 0.0 to 1.0.
 * @return color with new brightness = currentBrightness * brightness
*/
- (UIColor *)colorWithBrightnessComponent:(CGFloat)brightness;

@end
