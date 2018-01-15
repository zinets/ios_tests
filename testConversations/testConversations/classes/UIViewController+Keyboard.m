//
//  UIViewController+Keyboard.m
//  testConversations
//
//  Created by Zinets Viktor on 1/12/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "UIViewController+Keyboard.h"

typedef enum {
    KeyboardStatusWillShow,
    KeyboardStatusWillHide,
    KeyboardStatusDidShow,
    KeyboardStatusDidHide,
    KeyboardStatusWillChangeFrame,
    KeyboardStatusDidChangeFrame,
} KeyboardStatus;

@implementation UIViewController (Keyboard)

- (NSMutableDictionary *)storedConstants {
    static dispatch_once_t onceToken;
    static NSMutableDictionary *dictionary = nil;
    dispatch_once(&onceToken, ^{
        dictionary = [NSMutableDictionary dictionary];
    });
    
    return dictionary;
}

- (NSArray <NSLayoutConstraint *> *)bottomConstraints {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (([constraint.firstItem isEqual:self.bottomLayoutGuide] &&
            constraint.firstAttribute == NSLayoutAttributeTop &&
            constraint.secondAttribute == NSLayoutAttributeBottom) ||
            ([constraint.secondItem isEqual:self.bottomLayoutGuide] &&
             constraint.secondAttribute == NSLayoutAttributeTop &&
             constraint.firstAttribute == NSLayoutAttributeBottom)) {
                [arr addObject:constraint];
            }
    }
    return [arr copy];
}

- (void)registerKeyboard {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSLayoutConstraint *c in self.bottomConstraints) {
        dict[@(c.hash)] = @(c.constant);
    }
    self.storedConstants[@(self.hash)] = dict;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterKeyboard {
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self.storedConstants removeObjectForKey:@(self.hash)];
}

- (void)animateKeyboard:(CGFloat)duration options:(UIViewAnimationOptions)options {
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
       [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark observing

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *stored = [self storedConstants][@(self.hash)];
    if (stored.count) {
        CGRect frameEnd = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
        for (NSLayoutConstraint *c in self.bottomConstraints) {
            if (stored[@(c.hash)]) {
                CGFloat savedConstant = [stored[@(c.hash)] floatValue];
                c.constant = savedConstant + frameEnd.size.height;
            }
        }
        
        NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationOptions opt = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
        [self animateKeyboard:duration options:opt];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *stored = [self storedConstants][@(self.hash)];
    if (stored.count) {        
        for (NSLayoutConstraint *c in self.bottomConstraints) {
            if (stored[@(c.hash)]) {
                CGFloat savedConstant = [stored[@(c.hash)] floatValue];
                c.constant = savedConstant;
            }
        }
        
        NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        UIViewAnimationOptions opt = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
        [self animateKeyboard:duration options:opt];
    }
}

@end
