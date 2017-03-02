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

@implementation AnimatedTypiingLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponent];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initComponent];
    }
    return self;
}

- (void)initComponent {
    self.delayBetweenChars = 1/120.;
}

- (void)setText:(NSString *)newText animated:(BOOL)animated {
    if (animated) {
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

                                         [NSThread sleepForTimeInterval:self.delayBetweenChars];
                                     }];
        });
    } else {
        [super setText:newText];
    }
}

@end