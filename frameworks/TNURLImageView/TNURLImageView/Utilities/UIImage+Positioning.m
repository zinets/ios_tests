//
//  UIImage+Positioning.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/23/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "UIImage+Positioning.h"

@implementation UIImage (Positioning)


CGSize CGSizeFitInSize2(CGSize sourceSize, CGSize destSize) {
    CGFloat destScale;
    CGSize newSize = sourceSize;
    if (sourceSize.height > 0 && sourceSize.width > 0) {
        CGFloat scaleX = destSize.width / newSize.width;
        CGFloat scaleY = destSize.height / newSize.height;
        destScale = MIN(scaleX, scaleY); // мы фитим (вписываем) - по этому выбираем меньший скейл
        destScale = MIN(destScale, 1); // если размер больеше, чем sourceSize, то оставляем sourceSize
        newSize.width *= destScale;
        newSize.height *= destScale;
    }
    return newSize;
}


- (UIImage *)fitInSize:(CGSize)viewsize {
    
    CGSize size = CGSizeFitInSize2(self.size, viewsize);
    UIGraphicsBeginImageContext(viewsize);
    
    float dwidth = (viewsize.width - size.width) / 2.0f;
    float dheight = (viewsize.height - size.height) / 2.0f;
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)fillInSize:(CGSize)viewsize {
    CGSize size = self.size;
    CGFloat scalex = viewsize.width / size.width;
    CGFloat scaley = viewsize.height / size.height;
    CGFloat scale = MAX(scalex, scaley);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                viewsize.width,
                                                viewsize.height,
                                                8,
                                                0,
                                                colorSpace,
                                                kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    float dwidth = ((viewsize.width - width) / 2.0f);
    float dheight = ((viewsize.height - height) / 2.0f);
    CGRect newRect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, newRect, self.CGImage);
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end

