//
//  CountdownControl.h
//  likepackProto
//
//  Created by Victor Zinets on 6/19/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

/// контроль показывает оставшееся (в пределах 10 минут) время с отсчетом назад
@interface CountdownControl : UIView
@property (nonatomic) NSTimeInterval remainingTime;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fontColor;
-(void)test;
@end
