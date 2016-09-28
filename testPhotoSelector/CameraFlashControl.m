//
//  CameraFlashControl.m
//
//  Created by Alexander Dikhtyar on 27.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import "CameraFlashControl.h"
#import "CameraFlashButton.h"

@interface CameraFlashControl() {
	UIImageView *_flashIco;
	CameraFlashButton *_singleButton, *_btnAuto, *_btnOn, *_btnOff;
}
@property (nonatomic, readonly) CameraFlashControlState visualState;

@end

@implementation CameraFlashControl

- (id)initWithYOffset:(CGFloat)yOffset {
	return [self initWithFrame:CGRectMake(0, yOffset, 320, 35)];
}

#pragma mark - icon
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cameraState = CameraFlashStateAuto;
		_visualState = CameraFlashControlStateCollapsed;
        _flashIco = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"take-photo_transparent-button-icons_flash"] resizableImageWithCapInsets:(UIEdgeInsets){0,20,0,20}]];
		_flashIco.frame = CGRectOffset(_flashIco.frame, 9, 7);
		_singleButton = [self makeButtonWithTag:0 prevButtonMaxX:CGRectGetMaxX(_flashIco.frame)];
		_singleButton.alpha = 1.0;
		_btnAuto = [self makeButtonWithTag:0 prevButtonMaxX:CGRectGetMaxX(_flashIco.frame)];
		_btnOn = [self makeButtonWithTag:1 prevButtonMaxX:CGRectGetMaxX(_btnAuto.frame)];
		_btnOff = [self makeButtonWithTag:2 prevButtonMaxX:CGRectGetMaxX(_btnOn.frame)];
		[self addTarget:self action:@selector(selfPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_flashIco];
		[self addSubview:_singleButton];
		[self addSubview:_btnAuto];
		[self addSubview:_btnOn];
		[self addSubview:_btnOff];
		[self initSize];
    }
    return self;
}

#pragma mark - utility

- (CameraFlashButton *)makeButtonWithTag:(int)tag prevButtonMaxX:(CGFloat)prevButtonMaxX {
#warning настройки кнопок - как?
	NSString *title = [self buttonTitleForState:tag];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]}];
	CGFloat buttonWith = size.width;
	
	CameraFlashButton *res = [CameraFlashButton buttonWithType:(UIButtonTypeCustom)];
	res.frame = CGRectMake(prevButtonMaxX + (tag == 0 ? 4 : 20), 0, buttonWith, CGRectGetHeight(self.frame));
    [res setTitle:title forState:(UIControlStateNormal)];
	res.alpha = 0.0f;
	res.tag = tag;
	[res addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	return res;
}

- (NSString *)buttonTitleForState:(CameraFlashState)state {
	switch (state) {
		case CameraFlashStateAuto:
			return @"Auto";
		case CameraFlashStateOn:
			return @"On";
		case CameraFlashStateOff:
			return @"Off";
	}
	return @"";
}

- (void)initSize {
	CGRect frame = self.frame;
	CGFloat targetWidth = CGRectGetMaxX(_singleButton.frame) + 14;
	frame.size.width = targetWidth;
	frame.origin.x = self.center.x - targetWidth/2;
	self.frame = frame;
}

- (void)updateSize {
	CGFloat currentWidth = CGRectGetWidth(self.frame);
	CGFloat targetWidth = 0;
	if (self.visualState == CameraFlashControlStateCollapsed) {
		targetWidth = CGRectGetMaxX(_singleButton.frame) + 14;
	} else {
		targetWidth = CGRectGetMaxX(_btnOff.frame) + 14;
	}
	self.frame = CGRectInset(self.frame, (currentWidth - targetWidth)/2, 0);
	
}

#pragma mark - change visual state (collapse/expand)
- (void)toggleVisibleState {
	if (self.visualState == CameraFlashControlStateCollapsed) {
		[self expand];
	} else {
		[self collapse];
	}
}

- (void)expand {
	_visualState = CameraFlashControlStateExpanded;
	[UIView animateWithDuration:0.25 animations:^{
		[self updateSize];
		_singleButton.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.1 animations:^{
			_btnAuto.alpha = 1.0f;
			_btnOn.alpha = 1.0f;
			_btnOff.alpha = 1.0f;
		}];
	}];
	
}

- (void)collapse {
	_visualState = CameraFlashControlStateCollapsed;
	[UIView animateWithDuration:0.1 animations:^{
		_btnAuto.alpha = 0.0f;
		_btnOn.alpha = 0.0f;
		_btnOff.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.25 animations:^{
			[self updateSize];
			[_singleButton setTitle:[self buttonTitleForState:self.cameraState] forState:UIControlStateNormal];
			_singleButton.alpha = 1.0;
		}];
	}];
	
}


#pragma mark - actions
- (void)buttonPressed:(UIButton *)sender {
	if (self.visualState == CameraFlashControlStateCollapsed) {
		// do nothing
	} else {
		_cameraState = (int)sender.tag;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
	}
	[self toggleVisibleState];
}

- (void)selfPressed:(id)sender {
	[self toggleVisibleState];
}

@end
