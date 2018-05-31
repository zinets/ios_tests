//
//  GradientButton.h
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonGradientDirection) {
    ButtonGradientDirectionHorizontal,
    ButtonGradientDirectionDiagonal,
    ButtonGradientDirectionVertical,
};

IB_DESIGNABLE
@interface GradientButton : UIButton
@property (nonatomic, strong) IBInspectable UIColor *startGradientColor;
@property (nonatomic, strong) IBInspectable UIColor *endGradientColor;
@property (nonatomic) ButtonGradientDirection gradientDirection;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@end
