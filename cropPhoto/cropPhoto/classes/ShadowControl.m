//
// Created by Zinets Viktor on 10/3/17.
// Copyright (c) 2017 TogetherN. All rights reserved.
//

#import "ShadowControl.h"

@implementation ShadowControl {
    CALayer *shadowLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        shadowLayer = [CALayer layer];
        shadowLayer.frame = self.bounds;

        [self.layer addSublayer:shadowLayer];
    }

    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    shadowLayer.backgroundColor = backgroundColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    shadowLayer.frame = self.bounds;
}


@end