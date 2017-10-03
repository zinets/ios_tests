//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PhotoCropControl.h"

@interface PhotoCropControl ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation PhotoCropControl {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [self addSubview:self.imageView];
    }

    return self;
}

- (void)setImageToCrop:(UIImage *)imageToCrop {
    _imageToCrop = imageToCrop;
    self.imageView.image = _imageToCrop;
}

@end