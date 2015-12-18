//
//  UIView+Geometry.h
//  CupidDatingHD
//
//  Created by Zinetz Victor on 18.02.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIViewAutoresizingFlexibleSize (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)

CG_INLINE CGPoint CGRectGetCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

CG_INLINE BOOL CGRectIsLandscape(CGRect rect) {
    return rect.size.width > rect.size.height;
}

@interface UIView (Geometry)

@property CGPoint origin;
@property CGSize size;

@property CGFloat left;
@property CGFloat right;
@property CGFloat top;
@property CGFloat bottom;
@property CGFloat width;
@property CGFloat height;
@property CGFloat centerX;
@property CGFloat centerY;

@property CGPoint leftBottom; // и нахера может интересно понядобится такая проп :)
@property CGPoint rightBottom;

@end
