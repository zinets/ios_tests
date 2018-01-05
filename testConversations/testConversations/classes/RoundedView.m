//
// Created by Zinets Viktor on 1/5/18.
// Copyright (c) 2018 Zinets Viktor. All rights reserved.
//

#import "RoundedView.h"


@implementation RoundedView {
    CAShapeLayer *maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cornerRadius = 17;
        _corners = UIRectCornerAllCorners;
        [self updateMask];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _cornerRadius = 17;
        _corners = UIRectCornerAllCorners;
        [self updateMask];
    }

    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updateMask];
}

- (void)setCorners:(UIRectCorner)corners {
    _corners = corners;
    [self updateMask];
}

- (void)updateMask {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:self.corners
                                                     cornerRadii:(CGSize){self.cornerRadius, self.cornerRadius}];
    if (!maskLayer) {
        maskLayer = [CAShapeLayer layer];
        self.layer.mask = maskLayer;
    }

    maskLayer.path = path.CGPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateMask];
}


@end