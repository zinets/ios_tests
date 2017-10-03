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

@end

@implementation PhotoCropControl {
    CGPoint lastPoint;
}

// толщина уголка 6 пк
#define CORNER_WIDTH 6
// остаток ширины уголка (чтоб не пересчитывать все время)
#define CORNER_W2 18
#define HORIZONTAL_OFFSET 48
#define MINIMUM_CROP_SIZE 100

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

- (UIImageView *)leftTopCorner {
    if (!_leftTopCorner) {
        _leftTopCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropAngle"]];
        _leftTopCorner.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSizeRecognizer:)];
        [_leftTopCorner addGestureRecognizer:panR];
    }
    return _leftTopCorner;
}

- (UIImageView *)rightTopCorner {
    if (!_rightTopCorner) {
        _rightTopCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropAngle"]];
        _rightTopCorner.userInteractionEnabled = YES;
        _rightTopCorner.transform = CGAffineTransformMakeRotation(M_PI_2);
        UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSizeRecognizer:)];
        [_rightTopCorner addGestureRecognizer:panR];
    }
    return _rightTopCorner;
}

- (UIImageView *)leftBottomCorner {
    if (!_leftBottomCorner) {
        _leftBottomCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropAngle"]];
        _leftBottomCorner.userInteractionEnabled = YES;
        _leftBottomCorner.transform = CGAffineTransformMakeRotation(-M_PI_2);
        UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSizeRecognizer:)];
        [_leftBottomCorner addGestureRecognizer:panR];
    }
    return _leftBottomCorner;
}

- (UIImageView *)rightBottomCorner {
    if (!_rightBottomCorner) {
        _rightBottomCorner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropAngle"]];
        _rightBottomCorner.userInteractionEnabled = YES;
        _rightBottomCorner.transform = CGAffineTransformMakeRotation(M_PI);
        UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSizeRecognizer:)];
        [_rightBottomCorner addGestureRecognizer:panR];
    }
    return _rightBottomCorner;
}

- (ShadowControl *)shadowControl {
    if (!_shadowControl) {
        _shadowControl = [[ShadowControl alloc] initWithFrame:self.bounds];
        _shadowControl.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];

        UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPosRecognizer:)];
        [_shadowControl addGestureRecognizer:panR];
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

    CGFloat x = MIN(MAX(0, maskFrame.origin.x), frame.size.width - MINIMUM_CROP_SIZE);
    CGFloat y = MIN(MAX(0, maskFrame.origin.y), frame.size.height - MINIMUM_CROP_SIZE);
    CGFloat w = MAX(MIN(frame.size.width - x, maskFrame.size.width), MINIMUM_CROP_SIZE);
    CGFloat h = MAX(MIN(frame.size.height - y, maskFrame.size.height), MINIMUM_CROP_SIZE);

    _maskFrame = (CGRect){{x, y}, {w, h}}; // новая маска, в координатах картиночного вью
    CGRect frm = CGRectOffset(_maskFrame, self.imageView.frame.origin.x, self.imageView.frame.origin.y);

    CGPoint cornerPt = (CGPoint){frm.origin.x - CORNER_WIDTH, frm.origin.y - CORNER_WIDTH};
    frame = self.leftTopCorner.frame;
    frame.origin = cornerPt;
    self.leftTopCorner.frame = frame;

    cornerPt = (CGPoint){CGRectGetMaxX(frm) - CORNER_W2, frm.origin.y - CORNER_WIDTH};
    frame = self.rightTopCorner.frame;
    frame.origin = cornerPt;
    self.rightTopCorner.frame = frame;

    cornerPt = (CGPoint){frm.origin.x - CORNER_WIDTH, CGRectGetMaxY(frm) - CORNER_W2};
    frame = self.leftBottomCorner.frame;
    frame.origin = cornerPt;
    self.leftBottomCorner.frame = frame;

    cornerPt = (CGPoint){CGRectGetMaxX(frm) - CORNER_W2, CGRectGetMaxY(frm) - CORNER_W2};
    frame = self.rightBottomCorner.frame;
    frame.origin = cornerPt;
    self.rightBottomCorner.frame = frame;

    [self.shadowControl setFrameToUnmask:frm];
}

- (void)resetCrop {
    self.maskFrame = (CGRect){CGPointZero, self.imageView.bounds.size};
}

- (void)onSizeRecognizer:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            lastPoint = [sender locationInView:self];
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint pt = [sender locationInView:self];
            CGFloat dx = pt.x - lastPoint.x;
            CGFloat dy = pt.y - lastPoint.y;

            CGRect newMaskFrame = self.maskFrame;

            if (sender.view == self.leftTopCorner) {
                newMaskFrame.origin.x += dx;
                newMaskFrame.origin.y += dy;
                newMaskFrame.size.width -= dx;
                newMaskFrame.size.height -= dy;
            } else if (sender.view == self.rightTopCorner) {
                newMaskFrame.origin.y += dy;
                newMaskFrame.size.width += dx;
                newMaskFrame.size.height -= dy;
            } else if (sender.view == self.leftBottomCorner) {
                newMaskFrame.origin.x += dx;
                newMaskFrame.size.width -= dx;
                newMaskFrame.size.height += dy;
            } else if (sender.view == self.rightBottomCorner) {
                newMaskFrame.size.width += dx;
                newMaskFrame.size.height += dy;
            }

            [self setMaskFrame:newMaskFrame];
            lastPoint = pt;
        } break;
        default:
            break;
    }
}

- (void)onPosRecognizer:(UIPanGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            lastPoint = [sender locationInView:self];
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint pt = [sender locationInView:self];
            CGFloat dx = pt.x - lastPoint.x;
            CGFloat dy = pt.y - lastPoint.y;

            CGRect newMaskFrame = self.maskFrame;
            newMaskFrame.origin.x += dx;
            newMaskFrame.origin.y += dy;

            [self setMaskFrame:newMaskFrame];
            lastPoint = pt;
        } break;
        default:
            break;
    }
}

@end