//
//  BlindActivityIndicator2.h
//  blindActivityIndicator
//
//  Created by Victor Zinets on 11/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface BlindActivityIndicator2 : UIView
@property (nonatomic, strong) NSMutableArray <UIColor *> *activeColors;
@property (nonatomic, strong) NSMutableArray <UIColor *> *inactiveColors;

@property (nonatomic) NSTimeInterval updateTime;

@property (nonatomic) IBInspectable NSInteger numberOfDots;
@property (nonatomic) IBInspectable CGFloat dotRadius;
@property (nonatomic) IBInspectable CGFloat radius;

- (void)startAnimation;
- (void)stopAnimation;
@end

NS_ASSUME_NONNULL_END
