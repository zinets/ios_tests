//
//  PixelateImageProcessor.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/24/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "PixelateImageProcessor.h"
#import "PXLPixelator.h"


@implementation PixelateImageProcessor

+ (UIImage *)processImage:(UIImage *)image {
    CGFloat f = MIN(image.size.width, image.size.height);
    f /= 10;
    UIImage *resImg = [PXLPixelator create:image layers:@[
                                                      [PXLPixelateLayer layerWithShape:ShapeSquare size:f],
                                                      ]];
    return resImg;
}

@end
