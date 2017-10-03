//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCropControl : UIView
// берем картинку, вписываем в интерфейс и вернем фрейм - для анимирования
- (CGRect)setImageToCrop:(UIImage *)image;
// todo
@property (nonatomic, readonly) UIImage *croppedImage;
// todo
- (void)resetCrop;
@end