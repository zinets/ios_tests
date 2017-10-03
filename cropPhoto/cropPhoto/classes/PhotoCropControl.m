//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "PhotoCropControl.h"
#import "ShadowControl.h"

@interface PhotoCropControl ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ShadowControl *shadowControl;
// рамка для маскирования; "вычитаемая", внутри этого фрейма число, снаружи - заполнение; origin маска относительно начала картинки
@property (nonatomic) CGRect maskFrame;

@property (nonatomic, strong) UIImageView *leftTopCorner;
@property (nonatomic, strong) UIImageView *rightTopCorner;
@property (nonatomic, strong) UIImageView *leftBottomCorner;
@property (nonatomic, strong) UIImageView *rightBottomCorner;

// shadowing

@end

@implementation PhotoCropControl {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;

        [self addSubview:self.imageView];
        [self addSubview:self.shadowControl];

        [self addSubview:self.leftTopCorner];
        [self addSubview:self.rightTopCorner];
        [self addSubview:self.leftBottomCorner];
        [self addSubview:self.rightBottomCorner];
    }

    return self;
}

// толщина уголка 6 пк
#define CORNER_WIDTH 6
#define CORNER_W2 18
#define HORIZONTAL_OFFSET 48

- (UIImageView *)leftTopCorner {
    if (!_leftTopCorner) {
        _leftTopCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropAngle"]];
    }
    return _leftTopCorner;
}

- (UIImageView *)rightTopCorner {
    if (!_rightTopCorner) {
        _rightTopCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropAngle"]];
        _rightTopCorner.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    return _rightTopCorner;
}

- (UIImageView *)leftBottomCorner {
    if (!_leftBottomCorner) {
        _leftBottomCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropAngle"]];
        _leftBottomCorner.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    return _leftBottomCorner;
}

- (UIImageView *)rightBottomCorner {
    if (!_rightBottomCorner) {
        _rightBottomCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropAngle"]];
        _rightBottomCorner.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return _rightBottomCorner;
}

- (ShadowControl *)shadowControl {
    if (!_shadowControl) {
        _shadowControl = [[ShadowControl alloc] initWithFrame:self.bounds];
        _shadowControl.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    }
    return _shadowControl;
}

- (CGRect)setImageToCrop:(UIImage *)image {
    CGSize imageSize = image.size;
    CGSize controlSize = self.bounds.size;

    CGFloat x = MAX(1, imageSize.width / (controlSize.width - 2 * HORIZONTAL_OFFSET));
    CGFloat y = MAX(1, imageSize.height / (controlSize.height - 2 * HORIZONTAL_OFFSET)); // бо так проще
    CGFloat k = MAX(x, y);

    CGSize sz = {imageSize.width / k, imageSize.height / k};
    CGPoint pt = {(controlSize.width - sz.width) / 2, (controlSize.height - sz.height) / 2};

    self.imageView.frame = (CGRect){pt, sz};
    self.imageView.image = image;

    self.maskFrame = (CGRect){CGPointZero, sz};

    return self.imageView.frame;
}

- (void)setMaskFrame:(CGRect)maskFrame {
    CGRect frame = self.imageView.frame;
    maskFrame.size.width = MAX(100, maskFrame.size.width);
    maskFrame.size.height = MAX(100, maskFrame.size.height);

    _maskFrame = maskFrame;

    CGPoint cornerPt = (CGPoint){self.imageView.frame.origin.x + _maskFrame.origin.x - CORNER_WIDTH,
            self.imageView.frame.origin.y + _maskFrame.origin.y - CORNER_WIDTH};
    frame = self.leftTopCorner.frame;
    frame.origin = cornerPt;
    self.leftTopCorner.frame = frame;

    cornerPt = (CGPoint){CGRectGetMaxX(self.imageView.frame) - CORNER_W2,
            self.imageView.frame.origin.y + _maskFrame.origin.y - CORNER_WIDTH};
    frame = self.rightTopCorner.frame;
    frame.origin = cornerPt;
    self.rightTopCorner.frame = frame;

    cornerPt = (CGPoint){self.imageView.frame.origin.x + _maskFrame.origin.x - CORNER_WIDTH,
            CGRectGetMaxY(self.imageView.frame) - CORNER_W2};
    frame = self.leftBottomCorner.frame;
    frame.origin = cornerPt;
    self.leftBottomCorner.frame = frame;

    cornerPt = (CGPoint){CGRectGetMaxX(self.imageView.frame) - CORNER_W2,
            CGRectGetMaxY(self.imageView.frame) - CORNER_W2};
    frame = self.rightBottomCorner.frame;
    frame.origin = cornerPt;
    self.rightBottomCorner.frame = frame;

    [self.shadowControl setFrameToUnmask:self.imageView.frame];
}

- (void)resetCrop {
    self.maskFrame = (CGRect){CGPointZero, self.imageView.bounds.size};
}

@end