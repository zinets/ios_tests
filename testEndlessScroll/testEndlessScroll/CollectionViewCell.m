//
// Created by Zinets Victor on 2/9/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

#import "CollectionViewCell.h"


@implementation CollectionViewCell {
    UIView *smallBlock;
    UIView *bigBlock;
    CAGradientLayer *gradientLayer;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    smallBlock.backgroundColor = backgroundColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        smallBlock = [[UIView alloc] initWithFrame:(CGRect){{0, 0}, {60, 60}}];
        [self.contentView addSubview:smallBlock];

        bigBlock = [[UIView alloc] initWithFrame:(CGRect){{(frame.size.width - 150) / 2, 100}, {150, 150}}];
        bigBlock.backgroundColor = [UIColor darkGrayColor];
        {
            gradientLayer = [CAGradientLayer layer];
            gradientLayer.startPoint = (CGPoint) {0, 0};
            gradientLayer.endPoint = (CGPoint) {1, 1};
            gradientLayer.frame = bigBlock.bounds;
            [bigBlock.layer addSublayer:gradientLayer];
        }
        [self.contentView addSubview:bigBlock];
        self.layer.borderWidth = 2;
    }
    return self;
}

- (void)setCenterPos:(CGFloat)centerPos {
    // from -1 to 1
    bigBlock.transform = CGAffineTransformMakeTranslation(100 * centerPos, 0);
    if (centerPos > -0.5 && centerPos < 0.5) {
        gradientLayer.opacity = 1;
    } else {
        gradientLayer.opacity = 0;
    }
}

- (void)setColors:(NSArray<UIColor *> *)colors {
    _colors = colors;

    [gradientLayer removeFromSuperlayer];

    gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)colors[0].CGColor, (id)colors[1].CGColor];
    gradientLayer.startPoint = (CGPoint) {0, 0};
    gradientLayer.endPoint = (CGPoint) {1, 1};
    gradientLayer.frame = bigBlock.bounds;
    [bigBlock.layer addSublayer:gradientLayer];
}

@end
