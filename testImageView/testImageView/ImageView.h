//
//  ImageView.h
//  testImageView
//
//  Created by Zinets Victor on 2/17/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageView : UIScrollView
@property (nonatomic, strong) UIImage *image;
// к "пропорциональному заполнению" добавдяется сдвиг при необходимости картинки вниз т.о. чтобы "головы" оставались на виду
//@property (nonatomic) BOOL topAligned;
@property (nonatomic) BOOL zoomEnabled;
@end
