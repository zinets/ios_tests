//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PhotoCropperModePreview,
    PhotoCropperModeCrop,
    PhotoCropperModeCompleted,
} PhotoCropperMode;

@interface PhotoCropController : UIViewController
@property (nonatomic, assign) PhotoCropperMode mode;
@property (nonatomic, strong) UIImage *imageToCrop;
@end