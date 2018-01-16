//
// Created by Zinets Viktor on 1/5/18.
// Copyright (c) 2018 Zinets Viktor. All rights reserved.
//

#import "RoundedView.h"


@implementation RoundedView {
    CAShapeLayer *maskLayer;
    CAShapeLayer *borderLayer;
    UIColor *bgColor;
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

- (void)commonInit {
    _cornerRadius = 17;
    _corners = UIRectCornerAllCorners;
    [self updateMask];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updateMask];
}

- (void)setCorners:(UIRectCorner)corners {
    _corners = corners;
    [self updateMask];
}

- (void)setIsBorderVisible:(BOOL)isBorderVisible {
    _isBorderVisible = isBorderVisible;
    if (_isBorderVisible) {
        [super setBackgroundColor:[UIColor clearColor]];
    } else {
        [super setBackgroundColor:bgColor];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    bgColor = backgroundColor;
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

    if (!borderLayer) {
        borderLayer = [CAShapeLayer layer];
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:borderLayer];
    }
    borderLayer.strokeColor = self.isBorderVisible ? bgColor.CGColor : [UIColor clearColor].CGColor;
    borderLayer.path = path.CGPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateMask];
}


@end
