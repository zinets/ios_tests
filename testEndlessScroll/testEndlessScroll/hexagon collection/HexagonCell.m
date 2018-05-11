//
// Created by Victor Zinets on 5/11/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import "HexagonCell.h"

@interface HexagonCell()

@end

@implementation HexagonCell  {
    UIBezierPath *maskPath;
    CAShapeLayer *maskLayer;
}

- (void)commonInit {
    maskLayer = [CAShapeLayer layer];

    self.layer.mask = maskLayer;
    self.layer.masksToBounds = YES;
    [self updateMask];
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

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];

    [self updateMask];
}

-(void)updateMask {
    maskPath = [UIBezierPath bezierPath];
    CGFloat w = self.bounds.size.width / 2;
    CGFloat h = self.bounds.size.height / 2;
    [maskPath moveToPoint:(CGPoint){0, h}]; // 0
    [maskPath addLineToPoint:(CGPoint){w / 2, 0}]; // 1
    [maskPath addLineToPoint:(CGPoint){3 * w / 2, 0}]; // 2
    [maskPath addLineToPoint:(CGPoint){2 * w, h}]; // 3
    [maskPath addLineToPoint:(CGPoint){3 * w / 2, 2 * h}]; // 4
    [maskPath addLineToPoint:(CGPoint){w / 2, 2 * h}]; // 5
    [maskPath closePath]; // 0

    CABasicAnimation *animation = [CABasicAnimation animation];
    [maskLayer addAnimation:animation forKey:@"path animation"];
    maskLayer.path = maskPath.CGPath;
}

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if ([maskPath containsPoint:point]) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}


@end
