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
    self.delayBetweenChars = 1 / 10.;
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

- (void)setText2:(NSString *)newText animated:(BOOL)animated {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:newText];
    // сначала строка получает прозрачный цвет
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor clearColor]
                             range:NSMakeRange(0, newText.length)];
    self.attributedText = attributedString;

    // теперь к символам последовательно будет применяться нужный цвет с прозрачностью и полностью непрозрачный
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSInteger textLength = newText.length;
        UIColor *textColor = [UIColor blackColor]; //self.textColor;
        UIColor *semiColor = [UIColor lightGrayColor]; // [textColor colorWithAlphaComponent:0.6];
        for (int x = 0; x <= textLength; x++) {
            NSRange semiTransparentRange = (NSRange){x, MIN(2, textLength - x)};
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:semiColor
                                     range:semiTransparentRange];

            NSRange opacityRange = (NSRange){0, x};
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:textColor
                                     range:opacityRange];

            dispatch_async(dispatch_get_main_queue(), ^{
                self.attributedText = attributedString;
            });

            [NSThread sleepForTimeInterval:self.delayBetweenChars];

        }
    });


}

@end