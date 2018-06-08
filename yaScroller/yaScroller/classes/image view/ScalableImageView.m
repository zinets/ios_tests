//
// Created by Victor Zinets on 6/8/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import "ScalableImageView.h"


@implementation ScalableImageView {
    UIImageView *animatedImageView;
}

#define CONTENT_MODE_ANIMATION 0.25

- (void)setImage:(UIImage *)image {
    [super setImage:image];

    if (animatedImageView) {
        [animatedImageView removeFromSuperview];
        animatedImageView = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (animatedImageView) {
        animatedImageView.center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
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

    if (!animatedImageView) {
        animatedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        animatedImageView.contentMode = UIViewContentModeScaleToFill;
    }

    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFill:
            animatedImageView.frame = (CGRect){fillOrigin, fillSize};
            break;
        case UIViewContentModeScaleAspectFit:
            animatedImageView.frame = (CGRect){fitOrigin, fitSize};
            break;
        case UIViewContentModeScaleToFill:
            animatedImageView.frame = self.bounds;
            break;
        default:
            break;
    }

    animatedImageView.image = self.image;
    [self addSubview:animatedImageView];

    switch (contentMode) {
        case UIViewContentModeScaleAspectFill: {
            [UIView animateWithDuration:CONTENT_MODE_ANIMATION animations:^{
                animatedImageView.frame = (CGRect){fillOrigin, fillSize};
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [animatedImageView removeFromSuperview];
            }];
        } break;
        case UIViewContentModeScaleAspectFit: {
            [super setContentMode:contentMode];

            [UIView animateWithDuration:CONTENT_MODE_ANIMATION animations:^{
                animatedImageView.frame = (CGRect){fitOrigin, fitSize};
            } completion:^(BOOL finished) {
                [animatedImageView removeFromSuperview];
            }];
        } break;
        case UIViewContentModeScaleToFill: {
            [UIView animateWithDuration:CONTENT_MODE_ANIMATION animations:^{
                animatedImageView.frame = self.bounds;
            } completion:^(BOOL finished) {
                [super setContentMode:contentMode];
                [animatedImageView removeFromSuperview];
            }];
        } break;
        default:
            [super setContentMode:contentMode];
            break;
    }
}

@end
