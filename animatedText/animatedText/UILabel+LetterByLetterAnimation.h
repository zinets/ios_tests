//
// Created by Zinets Victor on 3/1/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LetterByLetterAnimation)
- (void)animateTextAppearing:(NSString *)newText charDelay:(NSTimeInterval)interval;
@end

@interface AnimatedTypiingLabel : UILabel {

}
@property (nonatomic) NSTimeInterval delayBetweenChars;
- (void)setText:(NSString *)newText animated:(BOOL)animated;
@end