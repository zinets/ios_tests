//
//  MessageTextStorage.m
//
//  Created by Zinets Victor on 2/22/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "MessageTextStorage.h"

@implementation MessageTextStorage

- (id)init {
    if (self = [super init]) {
        storage = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string {
    return storage.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [storage attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self beginEditing];
    [storage replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    [self beginEditing];
    [storage setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)processEditing {
    [super processEditing];
    
    static NSRegularExpression *iExpression;
//    NSString *pattern = @"\\B\\@([\\w\\-]+)";
//    NSString *pattern = @"\\B(?<!RT )(@[^ ]*)";
    NSString *pattern = @"\\B\\@([\\w\\-]*)"; // этот вариант самый-самый - срабатывает с "@", не срабатывает с "@aaa@aa"
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    
    NSRange paragaphRange = [self.string paragraphRangeForRange: self.editedRange];
    [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    
    [iExpression enumerateMatchesInString:self.string
                                  options:0 range:paragaphRange
                               usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
         
         if ((result.range.location + result.range.length) == (paragaphRange.location + paragaphRange.length)) {
             [self addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:result.range];
         }
     }];
}

@end
