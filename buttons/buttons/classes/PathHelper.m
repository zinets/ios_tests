//
//  PathHelper.m
//  buttons
//
//  Created by Zinets Victor on 10/27/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "PathHelper.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation PathHelper

#pragma mark -  internal

+ (CGPathRef)createCircleWithCenter:(CGPoint)center radius:(CGFloat)radius {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, center.x + radius, center.y);
    CGPathAddArc(path, nil, center.x, center.y, radius, 0, 2 * M_PI, false);
    
    return path;
}

+ (CGPathRef)createLineWithCenter:(CGPoint)center raduis:(CGFloat)radius angle:(CGFloat)angle offset:(CGPoint)offset {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat c = cos(angle);
    CGFloat s = sin(angle);
    
    CGPathMoveToPoint(path, nil, center.x + offset.x + radius * c, center.y + offset.y + radius * s);
    CGPathAddLineToPoint(path, nil, center.x + offset.x - radius * c, center.y + offset.y - radius * s);
    
    return path;
}

+ (CGPathRef)createLineWithCenter:(CGPoint)center raduis:(CGFloat)radius angle:(CGFloat)angle {
    return [self createLineWithCenter:center raduis:radius angle:angle offset:(CGPointZero)];
}

+ (CGPathRef)createLineFromStart:(CGPoint)start toEnd:(CGPoint)end offset:(CGPoint)offset {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, offset.x + start.x, offset.y + start.y);
    CGPathAddLineToPoint(path, nil, offset.x + end.x, offset.y + end.y);
    
    return path;
}

+ (CGPathRef)createLineFromStart:(CGPoint)start toEnd:(CGPoint)end {
    return [self createLineFromStart:start toEnd:end offset:(CGPointZero)];
}

#pragma mark - public

/// вернем массив из 4х path
+ (NSArray *)pathForButtonWithStyle:(ButtonStyle)style size:(CGFloat)size offset:(CGPoint)offset lineWidth:(CGFloat)lineWidth {
    CGPoint center = (CGPoint){offset.x + size / 2, offset.y + size / 2};
    
    CGPathRef line1Path, line2Path, line3Path, line4Path;
    
    switch (style) {
        case ButtonStyleHamburger:
            line1Path = [self createLineWithCenter:center raduis:size / 2 angle:0];
            line2Path = [self createLineWithCenter:center raduis:size / 2 angle:0 offset:(CGPoint){0, size / -3.2}];
            line3Path = [self createLineWithCenter:center raduis:size / 2 angle:0 offset:(CGPoint){0, size / 3.2}];
            line4Path = line1Path;
            break;
        case ButtonStyleArrowLeft:
            line1Path = [self createLineFromStart:CGPointMake(offset.x + lineWidth, center.y) toEnd:CGPointMake(offset.x + size, center.y)];
            line2Path = [self createLineFromStart:CGPointMake(offset.x + lineWidth, center.y) toEnd:CGPointMake(offset.x + size / 3.2, center.y + size /3.2)];
            line3Path = [self createLineFromStart:CGPointMake(offset.x + lineWidth, center.y) toEnd:CGPointMake(offset.x + size / 3.2, center.y - size /3.2)];
            line4Path = line1Path;
            break;
        default:
            line1Path = line2Path = line3Path = line4Path = CGPathCreateMutable();
            break;
    }
    
    
    return @[(__bridge id)line1Path, (__bridge id)line2Path, (__bridge id)line3Path, (__bridge id)line4Path];
}

@end
