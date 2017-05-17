//
//  Utils.m
//  TNUtils
//
//  Created by Stanislav Likholat on 23.10.14.
//  Copyright (c) 2014 Together Networks. All rights reserved.
//

#import "Utils.h"

@implementation Utils

BOOL isRetinaDisplay(){
    static BOOL isRetina = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isRetina = [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0);
    });
    return isRetina;
}


BOOL is35InchScreen() {
    static BOOL is35Inch = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        is35Inch = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480;
    });
    return is35Inch;
}


CGFloat screenWidth() {
    static CGFloat width = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        width = [UIScreen mainScreen].bounds.size.width;
    });
    return width;
}


ScreenSizeType screenSizeType() {
    static ScreenSizeType res = ScreenSize35;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (is55InchScreen()) {
            res = ScreenSize55;
        } else if (is47InchScreen()) {
            res = ScreenSize47;
        } else if (is4InchScreen()) {
            res = ScreenSize4;
        }
    });
    
    return res;
}


BOOL is4InchScreen() {
    static BOOL is4Inch = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        is4Inch = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568;
    });
    return is4Inch;
}

BOOL is47InchScreen() {
    static BOOL is47Inch = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        is47Inch = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667;
    });
    return is47Inch;
}

BOOL is55InchScreen() {
    static BOOL is55Inch = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        is55Inch = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736;
    });
    return is55Inch;
}

BOOL isIOS7OrLater()
{
    static BOOL isIOS7OrLater = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIOS7OrLater = ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending);
    });
    return isIOS7OrLater;
}

BOOL isIOS8OrLater()
{
    static BOOL isIOS8OrLater = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIOS8OrLater = ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending);
    });
    return isIOS8OrLater;
}

BOOL isIOS9OrLater()
{
    static BOOL isIOS9OrLater = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIOS9OrLater = ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending);
    });
    return isIOS9OrLater;
}

BOOL isIOS10OrLater()
{
    static BOOL isIOS10OrLater = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIOS10OrLater = ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending);
    });
    return isIOS10OrLater;
}

CGFloat statusBarHeight() {
    static CGFloat statusBarHeight = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //считаем, что у нас в приложении статус бар не может быть больше 20 пикселей и не учитываем, то что в состоянии in-call статус бар увеличивается до 40 пикселей
        statusBarHeight = MIN(20, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    });
    return statusBarHeight;
}

CGFloat effectiveStatusBarHeight ()
{
    static CGFloat statusBarHeight = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        statusBarHeight = isIOS7OrLater() ? MIN(20, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)) : 0;
    });
    return statusBarHeight;
}

CGFloat nativeScreenScale ()
{
    static CGFloat nativeScreenScale = 1.0f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIScreen *screen = [UIScreen mainScreen];
        if ([screen respondsToSelector:@selector(nativeScale)]) {
            nativeScreenScale = screen.nativeScale;
        } else {
            nativeScreenScale = screen.scale;
        }
    });
    return nativeScreenScale;
}


CGRect nativeScreenBounds ()
{
    static CGRect nativeScreenBounds;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nativeScreenBounds = [[UIScreen mainScreen] bounds];
    });
    return nativeScreenBounds;
}


CGFloat windowWidth() {
    static CGFloat windowWidth = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        windowWidth = [UIScreen mainScreen].bounds.size.width;
    });
    return windowWidth;
}


CGFloat windowHeight() {
    static CGFloat windowHeight = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        windowHeight = [UIScreen mainScreen].bounds.size.height;
    });
    return windowHeight;
}

#ifdef DEBUG
void borderControl(UIView * ctrl) {
    ctrl.layer.borderColor = RGB3(random()).CGColor;
    ctrl.layer.borderWidth = 1;
}

void strongBorderControl(UIView * ctrl) {
    ctrl.layer.borderColor = RGB3(random() && 0xff0000).CGColor;
    ctrl.layer.borderWidth = 2;
}
#else
void borderControl(UIView * ctrl) {}
void strongBorderControl(UIView * ctrl) {}
#endif
@end
