//
//  UIColor+InputMethods.h
//  Picks
//
//  Created by Joe on 5/22/13.
//  Copyright (c) 2013 mergesort. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (InputMethods)

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHex:(NSUInteger)hex;
+ (UIColor *)colorWithHex:(NSUInteger)hex
                    alpha:(CGFloat)alpha;

+ (NSString *)hexFromColor:(UIColor *)color;

+ (NSString *)stripHashtagFromHex:(NSString *)hexString;
+ (NSString *)addHashtagToHex:(NSString *)hexString;

- (UIColor *)darkenedColorByPercent:(float)percentage;
- (UIColor *)lightenedColorByPercent:(float)percentage;

- (UIColor *)tenPercentLighterColor;
- (UIColor *)twentyPercentLighterColor;
- (UIColor *)tenPercentDarkerColor;
- (UIColor *)twentyPercentDarkerColor;

@end
