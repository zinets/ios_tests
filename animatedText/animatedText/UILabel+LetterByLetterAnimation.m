//
// Created by Zinets Victor on 3/1/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

#import "UILabel+LetterByLetterAnimation.h"

// http://easings.net/

@implementation UILabel (LetterByLetterAnimation)

- (void)animateTextAppearing:(NSString *)newText charDelay:(NSTimeInterval)interval {
    self.text = @"";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        for (int x = 0; x < newText.length; x++) {
            NSString *str = [NSString stringWithFormat:@"%@%C", self.text, [newText characterAtIndex:x]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = str;
            });

            [NSThread sleepForTimeInterval:interval];
        }
    });
}

- (void)animateTextAppearing2:(NSString *)newText charDelay:(NSTimeInterval)interval {
    self.text = @"";
}

@end