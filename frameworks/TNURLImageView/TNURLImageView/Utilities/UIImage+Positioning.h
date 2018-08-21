//
//  UIImage+Positioning.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/23/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Positioning)

- (UIImage *)fitInSize:(CGSize)viewsize;
- (UIImage *)fillInSize:(CGSize)viewsize;

@end
