//
// Created by Zinets Viktor on 12/19/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "DiamondCell.h"


@implementation DiamondCell {
    UIBezierPath *maskPath;
    CAShapeLayer *maskLayer;
    UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];

        maskLayer = [CAShapeLayer layer];
        self.layer.mask = maskLayer;
        self.layer.masksToBounds = YES;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    maskPath = [UIBezierPath bezierPath]; {
        CGFloat w = self.bounds.size.width;
        CGFloat h = self.bounds.size.height;
        [maskPath moveToPoint:(CGPoint){w / 2, 0}];
        [maskPath addLineToPoint:(CGPoint){w, h / 2}];
        [maskPath addLineToPoint:(CGPoint){w / 2, h}];
        [maskPath addLineToPoint:(CGPoint){0, h / 2}];
        [maskPath closePath];
    }
    maskLayer.path = maskPath.CGPath;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if ([maskPath containsPoint:point]) {
        return self;
    } else {
        return nil;
    }
}

- (void)setNumber:(NSInteger)number {
    label.text = [NSString stringWithFormat:@"%@", @(number)];
}

@end