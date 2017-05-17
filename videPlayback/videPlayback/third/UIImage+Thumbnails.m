//
//  UIImage+Thumbnails.m
//  CupidDatingHD
//
//  Created by Zinetz Victor on 30.01.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "UIImage+Thumbnails.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Thumbnails)

CGSize CGSizeFitInSize(CGSize sourceSize, CGSize destSize) {    
    CGFloat destScale;
    CGSize newSize = sourceSize;
    if (newSize.height && (newSize.height > destSize.height)) {
        destScale = destSize.height / newSize.height;
        newSize.width *= destScale;
        newSize.height *= destScale;
    }
    if (newSize.width && (newSize.width >= destSize.width)) {
        destScale = destSize.width / newSize.width;
        newSize.width *= destScale;
        newSize.height *= destScale;
    }
    
    if (newSize.width < destSize.width || newSize.height < destSize.height) {
        destScale = destSize.width / destSize.height;
        CGFloat srcScale = sourceSize.width / sourceSize.height;
        if (destScale >= 1) {
            newSize.height = destSize.height;
            newSize.width = newSize.height * srcScale;
        } else {
            newSize.width = destSize.width;
            newSize.height = newSize.width * srcScale;
        }
    }
    
    return newSize;
}

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

-(UIImage *)fitInSize:(CGSize)viewsize {

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

-(UIImage *)centerInSize:(CGSize)viewsize {
    CGSize size = self.size;
    UIGraphicsBeginImageContext(viewsize);
    
    float dwidth = (viewsize.width - size.width) / 2.0f;
    float dheight = (viewsize.height - size.height) / 2.0f;
    CGRect rect = CGRectMake(dwidth, dheight, size.width, size.height);
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage *)fillInSize:(CGSize)viewsize {
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

-(UIImage *)fillFromTopInSize:(CGSize)viewsize {
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
    float dheight = viewsize.height - height;
    CGRect newRect = CGRectMake(dwidth, dheight, width, height);
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

-(UIImage *)croppedImage:(CGRect)cropRect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    
    UIImage * img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return img;
}

-(UIImage *)resizableImageLeftCap:(NSInteger)leftCapWidth topCap:(NSInteger)topCapHeight
                         rightCap:(NSInteger)rightCapWidth bottomCap:(NSInteger)bottomCapHeight {
    UIEdgeInsets e = UIEdgeInsetsMake(topCapHeight, leftCapWidth, bottomCapHeight, rightCapWidth);
    return [self resizableImageWithCapInsets:e resizingMode:UIImageResizingModeStretch];
}

-(UIImage *)rotateImageAtAngle:(CGFloat)angle {
    CGSize size = CGSizeMake(self.size.width * self.scale, self.size.height * self.scale);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, size.width/2, size.height/2);
    CGContextRotateCTM(bitmap, angle);
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

-(UIImage *)imageWithAlpha {
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          colorSpace, // CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight {
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

-(UIImage *)circledImage{
    return [self circledImageIn:CGRectMake(0, 0, self.size.width, self.size.height)];
}

-(UIImage *)circledImageIn:(CGRect)rect {
    UIImage * image = [self imageWithAlpha];
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 rect.size.width,
                                                 rect.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClosePath(context);
    CGContextEOClip(context);
    
    CGContextDrawImage(context, rect, image.CGImage);
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage * img = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return img;
}

- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self imageWithAlpha];
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                       context:context
                     ovalWidth:cornerSize
                    ovalHeight:cornerSize];
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

-(UIImage *)croppedWithMask:(UIImage *)maskImage {
    UIGraphicsBeginImageContext( maskImage.size );
    [self drawInRect:CGRectMake(0, 0, maskImage.size.width, maskImage.size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, YES);
    
    CGImageRef masked = CGImageCreateWithMask(newImage.CGImage, mask);
    CGImageRelease(mask);
    
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    return retImage;

}


- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}

- (UIImage *)_resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
	CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,
                                                0,
                                                cs,
                                                kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
	CGColorSpaceRelease(cs);
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self _resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

- (UIImage *)grayScaleImageWithBgColor:(UIColor *)bgColor {
    CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, imageRect);
    CGContextDrawImage(context, imageRect, [self CGImage]);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
        
    return newImage;
}

- (UIImage *)resizedToScreen {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat ar = screenWidth / self.size.width;
    if (ar == 1) {
        return self;
    } else {
        CGSize newSize = (CGSize){screenWidth, ar * self.size.height};
        return [self fillInSize:newSize];
    }
}

@end
