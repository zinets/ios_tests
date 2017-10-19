//
// Created by Zinets Viktor on 9/28/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "Pixelator.h"
#import "UIColor+Alpha.h"

#define SQRT2 1.414213562373095

@implementation Pixelator {

}

+ (UIImage *)create:(UIImage *)image layers:(NSArray <PixelateLayer *> *)layers {
    CGImageRef pixels = image.CGImage;
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;

    return [UIImage imageWithCGImage:
                    [self create:pixels inBounds:(CGRect){0, 0, w, h} width:w height:h layers:layers]
    ];
}

+ (CGImageRef)create:(CGImageRef)pixels
            inBounds:(CGRect)inBounds
               width:(NSInteger)width height:(NSInteger)height
        layers:(NSArray <PixelateLayer *> *)layers {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGRect outBounds = (CGRect){0, 0, width, height};

    CGContextRef canvas = CGBitmapContextCreate(nil, width, height, 8, 0, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextTranslateCTM(canvas, 0, outBounds.size.height);
    CGContextScaleCTM(canvas, 1, -1);
    [self render:pixels canvas:canvas outBounds:inBounds layers:layers];

    return CGBitmapContextCreateImage(canvas);
}

+ (void)render:(CGImageRef)pixels canvas:(CGContextRef)canvas outBounds:(CGRect)outBounds layers:(NSArray <PixelateLayer *> *)layers {
    CGFloat inWidth = CGImageGetWidth(pixels);
    CGFloat inHeight = CGImageGetHeight(pixels);
    CGFloat scaleX = outBounds.size.width / inWidth;
    CGFloat scaleY = outBounds.size.height / inHeight;

    CGContextSaveGState(canvas);
    CGContextTranslateCTM(canvas, outBounds.origin.x, outBounds.origin.y);
    CGContextScaleCTM(canvas, scaleX, scaleY);

    const UInt8 *data = CFDataGetBytePtr(CGDataProviderCopyData(CGImageGetDataProvider(pixels)));
    for (PixelateLayer *layer in layers) {
        CGFloat size = layer.size;
        NSInteger cols = inWidth / layer.resolution + 1;
        NSInteger rows = inHeight / layer.resolution + 1;
        CGFloat halfSize = size / 2;
        CGFloat diamondSize = size / SQRT2;
        CGFloat halfDiamondSize = diamondSize / 2;
        for (int row = 0; row < rows; row++) {
            NSInteger y = (row - 0.5) * layer.resolution + layer.offset;
            NSInteger pixelY = MAX(MIN(y, inHeight - 1), 0);
            for (int col = 0; col < cols; col++) {
                NSInteger x = (col - 0.5) * layer.resolution + layer.offset;
                NSInteger pixelX = MAX(MIN(x, inWidth - 1), 0);

                UIColor *color = [UIColor at: pixels data:data x:pixelX y:pixelY];
                CGContextSetFillColorWithColor(canvas, [color multiply:layer.alpha].CGColor);

                switch (layer.shape) {
                    case ShapeCircle:
                        CGContextAddArc(canvas, x, y, halfSize, 0, 2 * M_PI, NO);
                        break;
                    case ShapeDiamond:
                        CGContextSaveGState(canvas);
                        CGContextTranslateCTM(canvas, x, y);
                        CGContextRotateCTM(canvas, M_PI_4);
                        CGContextAddRect(canvas, (CGRect){-halfDiamondSize, -halfDiamondSize, 2 * halfDiamondSize, 2 * halfDiamondSize});
                        CGContextRestoreGState(canvas);
                        break;
                    case ShapeSquare: {
                        CGRect rect = (CGRect){x - halfSize, y - halfSize, 2 * halfSize, 2 * halfSize};
                        CGContextAddRect(canvas, rect);
                    } break;
                } // switch
                CGContextFillPath(canvas);
            }
        }
    }
    CGContextRestoreGState(canvas);
}

@end