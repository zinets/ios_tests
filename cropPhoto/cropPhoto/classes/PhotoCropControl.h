//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoCropControlDelegate
@required
- (void)cropControl:(id)sender didChangeMaskFrame:(BOOL)changed;
@end

@interface PhotoCropControl : UIView
// берем картинку, вписываем в интерфейс и вернем фрейм - для анимирования
- (CGRect)setImageToCrop:(UIImage *)image;
// вертаем маску в начальное состояние
- (void)resetCrop;
@property (nonatomic, readonly) UIImage *croppedImage;
@property (nonatomic, weak) id <PhotoCropControlDelegate> delegate;
@end