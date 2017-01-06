//
//  ProgressBlock.m
//  gradProgress
//
//  Created by Zinets Victor on 1/5/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import "ProgressBlock.h"

@implementation ProgressBlock {
    CAShapeLayer *outlineLayer, *bgStrokeLayer;
    CAGradientLayer *gradientLayerLeft, *gradientLayerRight;
}

@synthesize valueLabel, descriptionLabel;

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    _startColor = [UIColor grayColor];
    _endColor = [UIColor whiteColor];
    _inactiveColor = [UIColor grayColor];
    
    outlineLayer = [CAShapeLayer layer];
    
    CGFloat w = self.bounds.size.width / 2;
    CGFloat h = self.bounds.size.height / 2;
    const CGFloat lineWidth = 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:(CGPoint){w, h}
                                                        radius:MIN(w, h) - lineWidth
                                                    startAngle:M_PI_2
                                                      endAngle:M_PI_2 + 2 * M_PI
                                                     clockwise:YES];
    
    outlineLayer.path = path.CGPath;
    outlineLayer.strokeColor = [UIColor blackColor].CGColor;
    outlineLayer.fillColor = [UIColor clearColor].CGColor;
    outlineLayer.lineWidth = lineWidth;
    
    bgStrokeLayer = [CAShapeLayer layer];
    bgStrokeLayer.path = path.CGPath;
    bgStrokeLayer.strokeColor = self.inactiveColor.CGColor;
    bgStrokeLayer.fillColor = [UIColor clearColor].CGColor;
    bgStrokeLayer.lineWidth = lineWidth;
    [self.layer addSublayer:bgStrokeLayer];
    
    CGRect frm = self.bounds;
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = frm;
    
    frm.size.width /= 2;
    gradientLayerLeft = [CAGradientLayer layer];
    gradientLayerLeft.frame = frm;
    gradientLayerLeft.locations = @[@0, @1];
    [bgLayer addSublayer:gradientLayerLeft];
    
    frm.origin.x += frm.size.width;
    gradientLayerRight = [CAGradientLayer layer];
    gradientLayerRight.frame = frm;
    gradientLayerRight.locations = @[@0, @1];
    [bgLayer addSublayer:gradientLayerRight];
    
    bgLayer.mask = outlineLayer;
    [self.layer addSublayer:bgLayer];
    
    [self recreateGradient];
    
    valueLabel = [[UILabel alloc] initWithFrame:(CGRect){{0, 17}, {self.frame.size.width, 18}}];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:valueLabel];
    
    descriptionLabel = [[UILabel alloc] initWithFrame:(CGRect){{0, 30}, {self.frame.size.width, 21}}];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:descriptionLabel];
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(void)setProgress:(CGFloat)progress {
    _progress = MAX(0, MIN(progress, 1));
    valueLabel.text = [NSString stringWithFormat:@"%@%%", @(round(_progress * 100))];
    outlineLayer.strokeEnd = _progress;
}

- (void)recreateGradient {
    gradientLayerLeft.colors = @[(id)self.startColor.CGColor, (id)self.endColor.CGColor];
    gradientLayerRight.colors = @[(id)self.startColor.CGColor, (id)self.startColor.CGColor];
}

-(void)setStartColor:(UIColor *)startColor {
    _startColor = startColor;
    [self recreateGradient];
}

-(void)setEndColor:(UIColor *)endColor {
    _endColor = endColor;
    [self recreateGradient];
}

-(void)setInactiveColor:(UIColor *)inactiveColor {
    _inactiveColor = inactiveColor;
    bgStrokeLayer.strokeColor = _inactiveColor.CGColor;
}

@end
