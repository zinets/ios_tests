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
        [newText enumerateSubstringsInRange:(NSRange){0, newText.length}
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString *substring,
                                         NSRange substringRange,
                                         NSRange enclosingRange,
                                         BOOL *stop) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         self.text = [self.text stringByAppendingString:substring];
                                     });

                                     [NSThread sleepForTimeInterval:interval];
                                 }];
    });
}

@end