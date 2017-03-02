//
// Created by Zinets Victor on 3/1/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

#import "UILabel+LetterByLetterAnimation.h"

// http://easings.net/

@implementation UILabel (LetterByLetterAnimation)

- (void)animateTextAppearing:(NSString *)newText {
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

                                     [NSThread sleepForTimeInterval:1/100.];
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
    self.delayBetweenChars = 1 / 120.;
    self.semiTransparentColor = [self.textColor colorWithAlphaComponent:0.4];
}

- (void)setText:(NSString *)newText animated:(BOOL)animated {
    if (animated) {
        UIColor *textColor = self.textColor;
        UIColor *semiColor = self.semiTransparentColor;
        NSShadow *shadow1 = [[NSShadow alloc] init];
        shadow1.shadowBlurRadius = 1;

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:newText];
        // сначала строка получает прозрачный цвет
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor clearColor]
                                 range:NSMakeRange(0, newText.length)];
        self.attributedText = attributedString;

        // теперь к символам последовательно будет применяться нужный цвет с прозрачностью и полностью непрозрачный
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSInteger textLength = newText.length;
            for (int x = 0; x <= textLength; x++) {
                // пусть раз из 3х будет добавляться сразу 3 символа
                // но в начале текста пусть будет иногда добавляться только 1 символ
                NSInteger range = arc4random() % 3 == 0 ? 3 : 2;
                if (x < textLength / 5 || arc4random() % 3 == 0) {
                    range = arc4random() % 3 == 0 ? 2 : 1;
                }

                NSRange semiTransparentRange = (NSRange){x, MIN(range, textLength - x)}; {
                    NSDictionary *attrs = @{NSForegroundColorAttributeName: semiColor,
                            NSShadowAttributeName: shadow1};
                    [attributedString addAttributes:attrs
                                              range:semiTransparentRange];
                }

                NSRange opacityRange = (NSRange) {0, x}; {
                    [attributedString addAttribute:NSForegroundColorAttributeName
                                             value:textColor
                                             range:opacityRange];
                    [attributedString removeAttribute:NSShadowAttributeName
                                                range:opacityRange];
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    self.attributedText = attributedString;
                });

                [NSThread sleepForTimeInterval:self.delayBetweenChars];
            }
        });
    } else {
        [super setText:newText];
    }
}

@end