//
//  CameraFlashButton.m
//
//  Created by Alexander Dikhtyar on 27.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import "CameraFlashButton.h"

@implementation CameraFlashButton

- (void)setHighlighted:(BOOL)highlighted {
	UIButton *superview = (UIButton *)self.superview;
	if (superview && [superview isKindOfClass:[UIButton class]]) {
		[superview setHighlighted:highlighted];
	}
}

@end
