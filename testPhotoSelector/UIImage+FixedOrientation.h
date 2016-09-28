//
//  UIImage+FixedOrientation.h
//
//  Created by Zinets Victor on 9/28/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FixedOrientation)
- (UIImage*)scaleAndRotateImage:(float)maxResolution;
@end
