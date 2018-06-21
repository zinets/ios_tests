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
/// картинка рамки
@property (nonatomic, strong) IBInspectable UIImage *frameImage;
/// маска для обрезания картинки image внутри frameImage
@property (nonatomic, strong) IBInspectable UIImage *frameMaskImage;
/// картинка для обвивающей ленты; их кучка разных цветов
@property (nonatomic, strong) IBInspectable UIImage *ribbonImage;

@property (nonatomic, strong) IBInspectable NSString *ribbonTitle;
@property (nonatomic, strong) IBInspectable NSString *ribbonText;
@end
