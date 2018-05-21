//
//  ColorButton.h
//  PHProject
//
//  Created by Arakelyan on 9/12/14.
//  Copyright (c) 2014 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef LOCALIZATION_SUPPORT

typedef void(^OnButtonTapBlock)(UIButton *sender);

@interface ColorButton : UIButton

@property (nonatomic, strong) IBInspectable NSString *localizedTitle;
@property (nonatomic, copy) OnButtonTapBlock onTapBlock;

@property (nonatomic, strong) UIView *backgroundView;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
- (void)setTintColor:(UIColor *)color forState:(UIControlState)state;

- (UIColor *)backgroundColorForState:(UIControlState)state;

@property (nonatomic, assign) BOOL rounded;

@end


@interface CountedColorButton : ColorButton
@property (nonatomic, assign) NSInteger count;
@end