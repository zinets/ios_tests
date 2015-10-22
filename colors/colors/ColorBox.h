//
//  ColorBox.h
//  colors
//
//  Created by Zinets Victor on 10/20/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+HSV.h"
#import "UIView+Geometry.h"
#import "UIColor+MUIColor.h"

#include "core.h"


@interface ColorBox : UIView
@property (nonatomic) int hue;
@property (nonatomic) int brightness;
@property (nonatomic) int saturation;

- (void)setColor:(HSBColor)newColor;

@end
