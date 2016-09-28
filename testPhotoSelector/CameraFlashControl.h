//
//  CameraFlashControl.h
//
//  Created by Alexander Dikhtyar on 27.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Specifies visible state: collapsed/expanded
typedef enum {
	CameraFlashControlStateCollapsed,
	CameraFlashControlStateExpanded,
} CameraFlashControlState;

/// Specifies flash mode: auto, on, off
typedef enum {
	CameraFlashStateAuto,
	CameraFlashStateOn,
	CameraFlashStateOff,
} CameraFlashState;

@interface CameraFlashControl : UIButton

/// Call this method to determine which type of flash is selected
@property (nonatomic, readonly) CameraFlashState cameraState;

/// Use only this initializer. Inits switcher with specified offset by Y
- (id)initWithYOffset:(CGFloat)yOffset;

@end
