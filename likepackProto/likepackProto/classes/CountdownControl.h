//
//  CountdownControl.h
//  likepackProto
//
//  Created by Victor Zinets on 6/19/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

/// контроль показывает оставшееся (в пределах 10 минут) время с отсчетом назад
IB_DESIGNABLE
@interface CountdownControl : UIView
@property (nonatomic) NSTimeInterval remainingTime;
@property (nonatomic, strong) UIFont *digitFont; 
@property (nonatomic, strong) IBInspectable UIColor *digitColor;
@end
