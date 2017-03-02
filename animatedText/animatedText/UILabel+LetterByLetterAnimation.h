//
// Created by Zinets Victor on 3/1/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LetterByLetterAnimation)
- (void)animateTextAppearing:(NSString *)newText;
@end

@interface AnimatedTypiingLabel : UILabel {

}
@property (nonatomic) NSTimeInterval delayBetweenChars;
/// цвет, который используется для анимированного проявления текста - по умолчанию будет равен цвету текста с прозрачностью 0,4
@property (nonatomic, strong) UIColor *semiTransparentColor;
- (void)setText:(NSString *)newText animated:(BOOL)animated;
@end