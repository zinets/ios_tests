//
//  Utils.h
//  TNUtils
//
//  Created by Stanislav Likholat on 23.10.14.
//  Copyright (c) 2014 Together Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGB3(color)  [UIColor colorWithRed:((color & 0xff0000) >> 16) / 255.0f \
                                     green:((color & 0xff00) >> 8) / 255.0f \
                                      blue:(color & 0xff) / 255.0f \
                                     alpha:1.0]

typedef NS_ENUM(NSUInteger, ScreenSizeType) {
    ScreenSize35,
    ScreenSize4,
    ScreenSize47,
    ScreenSize55,
};

@interface Utils : NSObject

BOOL isRetinaDisplay();
BOOL is35InchScreen();
BOOL is4InchScreen();
BOOL is47InchScreen();
BOOL is55InchScreen();
BOOL isIOS7OrLater();
BOOL isIOS8OrLater();
BOOL isIOS9OrLater();
BOOL isIOS10OrLater();
CGFloat screenWidth();

ScreenSizeType screenSizeType();

void borderControl(UIView * ctrl);
void strongBorderControl(UIView * ctrl);

CGFloat statusBarHeight();
CGFloat effectiveStatusBarHeight (); // высота статусбара в зависимости от версии ios
CGFloat nativeScreenScale();
CGRect nativeScreenBounds ();

CGFloat windowWidth();
CGFloat windowHeight();

@end
