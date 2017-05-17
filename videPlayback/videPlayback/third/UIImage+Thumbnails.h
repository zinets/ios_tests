//
//  UIImage+Thumbnails.h
//  CupidDatingHD
//
//  Created by Zinetz Victor on 30.01.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumbnails)

-(UIImage *)fitInSize:(CGSize)viewsize;
-(UIImage *)centerInSize:(CGSize)viewsize;
-(UIImage *)fillInSize:(CGSize)viewsize;
/// заполняем картинкой указанный размер таким образом, чтобы заполнение шло сверху вниз; опционально можно указать сдвиг вверх
-(UIImage *)fillFromTopInSize:(CGSize)viewsize;

-(UIImage *)croppedImage:(CGRect)cropRect;
-(UIImage *)resizableImageLeftCap:(NSInteger)leftCapWidth topCap:(NSInteger)topCapHeight
                         rightCap:(NSInteger)rightCapWidth bottomCap:(NSInteger)bottomCapHeight;
-(UIImage *)rotateImageAtAngle:(CGFloat)angle;

-(UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;
-(UIImage *)circledImage;
-(UIImage *)circledImageIn:(CGRect)rect;

-(UIImage *)croppedWithMask:(UIImage *)maskImage;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)grayScaleImageWithBgColor:(UIColor *)bgColor;

/// имеется в виду, что этот метод посчитает, насколько надо увеличить картинку, чтобы она в ширину заняла столько, сколько экран текущего дивайса (320, 375, 414), и увеличит картинку с пропорциональным заполнением расчитанной области
- (UIImage *)resizedToScreen;
@end
