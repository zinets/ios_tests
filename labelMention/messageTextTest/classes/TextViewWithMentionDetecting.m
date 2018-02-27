//
//  TextViewWithMentionDetecting.m
//  messageTextTest
//
//  Created by Victor Zinets on 2/26/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "TextViewWithMentionDetecting.h"

@implementation TextViewWithMentionDetecting {
    NSRegularExpression *expression;
}

- (void)commonInit {
    NSString *pattern = @"\\B\\@([\\w\\-]*)"; // этот вариант самый-самый - срабатывает с "@", не срабатывает с "@aaa@aa"
    expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textWasChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textWasChanged:(NSNotification *)n {
    NSRange range = (NSRange){0, self.text.length};
    
    __block BOOL hasOne = NO;
    [expression enumerateMatchesInString:self.text
                                 options:0 range:range
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  
                                  if ((result.range.location + result.range.length) == (range.location + range.length)) {
                                      hasOne = YES;
                                      NSString *s = [self.text substringWithRange:(NSRange){result.range.location + 1, result.range.length - 1}];
                                      if ([self.mentionDelegate respondsToSelector:@selector(textStorage:didFindMention:)]) {
                                          [self.mentionDelegate textStorage:self didFindMention:s];
                                      }
                                  }
                              }];
    if (!hasOne && [self.mentionDelegate respondsToSelector:@selector(textStorageHasntMention:)]) {
        [self.mentionDelegate textStorageHasntMention:self];
    }
}

- (void)replaceLastMentionWith:(NSString *)fullMention {
    NSRange range = (NSRange){0, self.text.length};
    [expression enumerateMatchesInString:self.text
                                 options:0 range:range
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  if ((result.range.location + result.range.length) == (range.location + range.length)) {
                                      // в списке для подстановке нет @ в начале, соотв. надо здесь добавлять
                                      [self.textStorage replaceCharactersInRange:result.range withString:[NSString stringWithFormat:@"@%@", fullMention]];
                                      
                                      // cursor
                                      self.selectedTextRange = [self textRangeFromPosition:self.endOfDocument toPosition:self.endOfDocument];
                                  }
                              }];
}

@end
