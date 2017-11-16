//
// Created by Zinets Viktor on 9/28/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "UIColor+Alpha.h"


@implementation UIColor (Alpha)

- (UIColor *)multiply:(CGFloat)alpha {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:r green:g blue:b alpha:a * alpha];
}

+ (UIColor *)at:(CGImageRef)image data:(const UInt8 *)data x:(NSInteger)x y:(NSInteger)y {
    NSInteger index = CGImageGetBytesPerRow(image) * y + x * CGImageGetBitsPerPixel(image) / 8;
    UIColor *color;
    switch (CGImageGetAlphaInfo(image)) {
        case kCGImageAlphaOnly:
            color = [UIColor colorWithRed:0 green:0 blue:0 alpha:data[index] / 255.];
            break;
        case kCGImageAlphaNone:
        case kCGImageAlphaNoneSkipLast:
            color = [UIColor colorWithRed:data[index] / 255.
                                    green:data[index + 1] / 255.
                                     blue:data[index + 2] / 255.
                                    alpha:1];
            break;
        case kCGImageAlphaNoneSkipFirst:
            color = [UIColor colorWithRed:data[index + 1] / 255.
                                    green:data[index + 2] / 255.
                                     blue:data[index + 3] / 255.
                                    alpha:1];
            break;
        case kCGImageAlphaFirst:
            color = [UIColor colorWithRed:data[index + 1] / 255.
                                    green:data[index + 2] / 255.
                                     blue:data[index + 3] / 255.
                                    alpha:data[index] / 255.];
            break;
        case kCGImageAlphaLast:
            color = [UIColor colorWithRed:data[index] / 255.
                                    green:data[index + 1] / 255.
                                     blue:data[index + 2] / 255.
                                    alpha:data[index + 3] / 255.];
            break;
        case kCGImageAlphaPremultipliedLast:
            color = [UIColor colorWithRed:data[index] / 255.
                                    green:data[index + 1] / 255.
                                     blue:data[index + 2] / 255.
                                    alpha:1];
            break;
        case kCGImageAlphaPremultipliedFirst:
            color = [UIColor colorWithRed:data[index + 1] / 255.
                                    green:data[index + 2] / 255.
                                     blue:data[index + 3] / 255.
                                    alpha:1];
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
    return color;
}

+ (UIColor *)at:(CGImageRef)image x:(NSInteger)x y:(NSInteger)y {
    CGDataProviderRef pixelData = CGImageGetDataProvider(image);

    if (pixelData) {
        return [self at:image data:CFDataGetBytePtr(CGDataProviderCopyData(pixelData)) x:x y:y];
    } else {
        return nil;
    }
}

@end