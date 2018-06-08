//
// Created by Victor Zinets on 6/8/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import "ScalableImageView.h"

@interface ScalableImageView ()
@property(nonatomic, strong) UIImageView *animatedImageView;
@end

@implementation ScalableImageView

-(void)commonInit {
    _contentModeAnimationDuration = 0.25;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithImage:(nullable UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];

    if (self.animatedImageView) {
        [self.animatedImageView removeFromSuperview];
        self.animatedImageView = nil;
    }
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    if (!self.image || contentMode == self.contentMode) return;

    CGSize viewSize = self.bounds.size;
    CGSize imageSize = self.image.size;
    CGFloat arX = imageSize.width / viewSize.width;
    CGFloat arY = imageSize.height / viewSize.height;

    CGFloat fillAR = MIN(arX, arY);
    CGSize fillSize = (CGSize){imageSize.width / fillAR, imageSize.height / fillAR};
    CGPoint fillOrigin = (CGPoint){(viewSize.width - fillSize.width) / 2, (viewSize.height - fillSize.height) / 2};

    CGFloat fitAR = MAX(arX, arY);
    CGSize fitSize = (CGSize){imageSize.width / fitAR, imageSize.height / fitAR};
    CGPoint fitOrigin = (CGPoint){(viewSize.width - fitSize.width) / 2, (viewSize.height - fitSize.height) / 2};

    if (!self.animatedImageView) {
        self.animatedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.animatedImageView.contentMode = UIViewContentModeScaleToFill;
        self.animatedImageView.clipsToBounds = YES;

//        self.animatedImageView.layer.borderColor = [UIColor magentaColor].CGColor;
//        self.animatedImageView.layer.borderWidth = 2;
    }

    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFill:
            self.animatedImageView.frame = (CGRect){fillOrigin, fillSize};
            break;
        case UIViewContentModeScaleAspectFit:
            self.animatedImageView.frame = (CGRect){fitOrigin, fitSize};
            break;
        case UIViewContentModeScaleToFill:
            self.animatedImageView.frame = self.bounds;
            break;
        case UIViewContentModeCenter:
            self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, (viewSize.height - imageSize.height) / 2}, self.image.size};
            break;
        case UIViewContentModeRedraw:
            break;
        case UIViewContentModeTop:
            self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, 0}, self.image.size};
            break;
        case UIViewContentModeBottom:
            self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, viewSize.height - imageSize.height}, self.image.size};
            break;
        case UIViewContentModeLeft:
            self.animatedImageView.frame = (CGRect){{0, (viewSize.height - imageSize.height) / 2}, self.image.size};
            break;
        case UIViewContentModeRight:
            self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, (viewSize.height - imageSize.height) / 2}, self.image.size};
            break;
        case UIViewContentModeTopLeft:
            self.animatedImageView.frame = (CGRect){CGPointZero, self.image.size};
            break;
        case UIViewContentModeTopRight:
            self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, 0}, self.image.size};
            break;
        case UIViewContentModeBottomLeft:
            self.animatedImageView.frame = (CGRect){{0, viewSize.height - imageSize.height}, self.image.size};
            break;
        case UIViewContentModeBottomRight:
            self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, viewSize.height - imageSize.height}, self.image.size};
            break;
    }

    self.animatedImageView.image = self.image;
    [self addSubview:self.animatedImageView];

    switch (contentMode) {
        case UIViewContentModeScaleAspectFill: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect) {fillOrigin, fillSize};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];

            break;
        }
        case UIViewContentModeScaleAspectFit: {
            [super setContentMode:contentMode];

            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect) {fitOrigin, fitSize};
            } completion:^(BOOL finished) {
                [self.animatedImageView removeFromSuperview];
            }];

            break;
        }
        case UIViewContentModeScaleToFill: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = self.bounds;
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];

            break;
        }
        case UIViewContentModeCenter: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, (viewSize.height - imageSize.height) / 2}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeRedraw:
            [super setContentMode:contentMode];
            [self.animatedImageView removeFromSuperview];
            break;
        case UIViewContentModeTop: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, 0}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeBottom: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{(viewSize.width - imageSize.width) / 2, viewSize.height - imageSize.height}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeLeft: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{0, (viewSize.height - imageSize.height) / 2}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeRight: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, (viewSize.height - imageSize.height) / 2}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeTopLeft: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){CGPointZero, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeTopRight: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, 0}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeBottomLeft: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{0, viewSize.height - imageSize.height}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
        case UIViewContentModeBottomRight: {
            [UIView animateWithDuration:_contentModeAnimationDuration animations:^{
                self.animatedImageView.frame = (CGRect){{viewSize.width - imageSize.width, viewSize.height - imageSize.height}, self.image.size};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [self.animatedImageView removeFromSuperview];
            }];
            break;
        }
    }
}

@end
