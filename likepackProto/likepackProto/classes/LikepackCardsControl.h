//
//  LikepackCardsControl.h
//  likepackProto
//
//  Created by Victor Zinets on 6/20/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface LikepackCardsControl : UIView
/// картинка для показа в рамке
@property (nonatomic, strong) IBInspectable UIImage *image;
@property (nonatomic, strong) NSString *imageUrl;
/// картинка рамки
@property (nonatomic, strong) IBInspectable UIImage *frameImage;
/// маска для обрезания картинки image внутри frameImage
@property (nonatomic, strong) IBInspectable UIImage *frameMaskImage;
/// картинка для обвивающей ленты; их кучка разных цветов
@property (nonatomic, strong) IBInspectable UIImage *ribbonImage;
/// тексты в ленте "выпускник-2018"
@property (nonatomic, strong) IBInspectable NSString *ribbonText;
/// видимость обратного отсчетчика
@property (nonatomic) IBInspectable BOOL isCountdownVisible;
/// остаток обратного отсчета
@property (nonatomic) NSTimeInterval countdownRemainingTime;
@end
