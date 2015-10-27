//
//  PathHelper.h
//  buttons
//
//  Created by Zinets Victor on 10/27/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonStyle) {
    ButtonStyleHamburger,
};

@interface PathHelper : NSObject
+ (NSArray *)pathForButtonWithStyle:(ButtonStyle)style size:(CGFloat)size offset:(CGPoint)offset lineWidth:(CGFloat)lineWidth;
    
@end
