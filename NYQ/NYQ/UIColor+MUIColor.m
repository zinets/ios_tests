//
//  UIColor+MUIColor.m
//  MUIControls
//
//  Created by Kozharin on 05.03.13.
//  Copyright (c) 2013 iCupid. All rights reserved.
//

#import "UIColor+MUIColor.h"

@implementation UIColor (MUIColor)
+(UIColor*)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha{
    return [UIColor colorWithRed: ((hex & 0xff0000)>>16)  /255.0f green:((hex & 0x00ff00)>>8)/255.0f blue:(hex & 0xff)/255.0f alpha:alpha];
}
+(UIColor*)colorWithHex:(NSUInteger)hex{
    return [UIColor colorWithRed: ((hex & 0xff0000)>>16)  /255.0f green:((hex & 0x00ff00)>>8)/255.0f blue:(hex & 0xff)/255.0f alpha:1];
}

@end
