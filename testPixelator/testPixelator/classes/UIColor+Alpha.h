//
// Created by Zinets Viktor on 9/28/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Alpha)
- (UIColor *)multiply:(CGFloat)alpha;
+ (UIColor *)at:(CGImageRef)image x:(NSInteger)x y:(NSInteger)y;
+ (UIColor *)at:(CGImageRef)image data:(const UInt8 *)data x:(NSInteger)x y:(NSInteger)y;
@end