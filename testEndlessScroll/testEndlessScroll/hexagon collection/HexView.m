//
//  HexView.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/11/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "HexView.h"

#define sin60 0.8660254

@implementation HexView {
    CAShapeLayer *maskLayer;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        maskLayer = [CAShapeLayer layer];
        
        self.layer.mask = maskLayer;
        self.layer.masksToBounds = YES;
        [self updateMask];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self updateMask];
}

-(void)updateMask {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat w = self.bounds.size.width / 2;
    CGFloat h = self.bounds.size.height / 2;
    [path moveToPoint:(CGPoint){0, h}]; // 0
    [path addLineToPoint:(CGPoint){w / 2, 0}]; // 1
    [path addLineToPoint:(CGPoint){3 * w / 2, 0}]; // 2
    [path addLineToPoint:(CGPoint){2 * w, h}]; // 3
    [path addLineToPoint:(CGPoint){3 * w / 2, 2 * h}]; // 4
    [path addLineToPoint:(CGPoint){w / 2, 2 * h}]; // 5
    [path closePath]; // 0
    
    maskLayer.path = path.CGPath;
}

@end
