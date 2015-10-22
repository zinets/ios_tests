//
//  UIColor+HSV.h
//  colors
//
//  Created by Zinets Victor on 10/20/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HSV)
+ (UIColor *)colorWithH:(int)hue S:(int)saturation B:(int)brightness;
@end