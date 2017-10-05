//
//  CropImagePreview.h
//  cropPhoto
//
//  Created by Zinets Viktor on 10/5/17.
//  Copyright © 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropImagePreview : UIView
@property (nonatomic, strong) UIImage *image;
- (instancetype)initWithImage:(UIImage *)image;
@end
