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
    CAShapeLayer *progressLayer;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // progress
        progressLayer = [CAShapeLayer layer];
        progressLayer.fillColor = [UIColor clearColor].CGColor;
                
        progressLayer.strokeColor = [UIColor redColor].CGColor;
        progressLayer.strokeStart = 0;
        progressLayer.strokeEnd = 0;
        progressLayer.lineWidth = 5;
        [self.layer addSublayer:progressLayer];

        // mask
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
    [self updateProgressPath];
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

- (void)updateProgressPath {
    progressLayer.frame = self.bounds;
    // другой path нужен потому, что для прогрес-бара начало должно быть в "12" часов
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat w = self.bounds.size.width / 2;
    CGFloat h = self.bounds.size.height / 2;
    [path moveToPoint:(CGPoint){w, 0}]; // 0
    [path addLineToPoint:(CGPoint){3 * w / 2, 0}]; // 1
    [path addLineToPoint:(CGPoint){2 * w, h}]; // 2
    [path addLineToPoint:(CGPoint){3 * w / 2, 2 * h}]; // 3
    [path addLineToPoint:(CGPoint){w / 2, 2 * h}]; // 4
    [path addLineToPoint:(CGPoint){0, h}]; // 5
    [path addLineToPoint:(CGPoint){w / 2, 0}]; // 6
    [path closePath]; // 0

    progressLayer.path = path.CGPath;
}

-(void)setProgress:(CGFloat)progress {
    _progress = MAX(0, MIN(1, progress));
    progressLayer.strokeEnd = _progress;
}

@end
