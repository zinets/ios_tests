//
//  UIColor+InputMethods.m
//  Picks
//
//  Created by Joe on 5/22/13.
//  Copyright (c) 2013 mergesort. All rights reserved.
//

#import "UIColor+InputMethods.h"


@implementation UIColor (InputMethods)

+ (UIColor*)colorWithHex:(NSUInteger)hex
                   alpha:(CGFloat)alpha {
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


+ (UIColor *)colorWithHexString:(NSString *)hexString
{
	NSString *trimmedString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    //Only take the last 6 characters ever, so someone can prefix it with #, 0x, or whatever they want
    if (trimmedString.length != 6)
    {
        trimmedString = [trimmedString substringWithRange:NSMakeRange(trimmedString.length-6, 6)];
    }
    
    NSRange range = NSMakeRange(0, 2);
	NSString *red = [trimmedString substringWithRange:range];
	
	range.location = 2;
	NSString *green = [trimmedString substringWithRange:range];
	
	range.location = 4;
	NSString *blue = [trimmedString substringWithRange:range];
	
	unsigned int r, g, b;
	[[NSScanner scannerWithString:red] scanHexInt:&r];
	[[NSScanner scannerWithString:green] scanHexInt:&g];
	[[NSScanner scannerWithString:blue] scanHexInt:&b];

	return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (NSString *)hexFromColor:(UIColor *)color
{
    if (color == nil || color == [UIColor whiteColor])
    {
        //[UIColor whiteColor] isn't in the RGB spectrum
        return @"#ffffff";
    }
    
    CGFloat red, blue, green, alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSUInteger redInt = (NSUInteger)(red*255);
    NSUInteger greenInt = (NSUInteger)(green*255);
    NSUInteger blueInt = (NSUInteger)(blue*255);
    
    NSString *returnString = [NSString stringWithFormat:@"#%02x%02x%02x", (unsigned int)redInt, (unsigned int)greenInt, (unsigned int)blueInt];
    
    return returnString;
}

+ (NSString *)stripHashtagFromHex:(NSString *)hexString
{
    return ([hexString hasPrefix:@"#"]) ? [hexString substringFromIndex:1] : hexString;
}

+ (NSString *)addHashtagToHex:(NSString *)hexString
{
    return ([hexString hasPrefix:@"#"]) ? hexString : [@"#" stringByAppendingString:hexString];
}

- (UIColor *)darkenedColorByPercent:(float)percentage
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;

    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    double multiplier = 1.0-percentage;
    
    return [UIColor colorWithRed:red*multiplier green:green*multiplier blue:blue*multiplier alpha:alpha];
}

- (UIColor *)lightenedColorByPercent:(float)percentage
{
    return [self darkenedColorByPercent:-percentage];
}

- (UIColor *)tenPercentLighterColor
{
    return [self lightenedColorByPercent:0.1];
}

- (UIColor *)twentyPercentLighterColor
{
    return [self lightenedColorByPercent:0.2];
}

- (UIColor *)tenPercentDarkerColor
{
    return [self darkenedColorByPercent:0.1];
}

- (UIColor *)twentyPercentDarkerColor
{
    return [self darkenedColorByPercent:0.2];
}

@end
