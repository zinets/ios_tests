//
//  UIColor+MUIColor.h
//  MUIControls
//
//  Created by Kozharin on 05.03.13.
//  Copyright (c) 2013 iCupid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MUIColor)
+(UIColor*)colorWithHex:(NSUInteger)hex;
+(UIColor*)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;
@end
