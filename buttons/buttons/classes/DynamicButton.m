//
//  DynamicButton.m
//  buttons
//
//  Created by Zinets Victor on 10/27/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "DynamicButton.h"

@interface DynamicButton () {
    CGFloat intSize;
    CGPoint intOffset;
}
@property (nonatomic, strong) CAShapeLayer *line1Layer;
@property (nonatomic, strong) CAShapeLayer *line2Layer;
@property (nonatomic, strong) CAShapeLayer *line3Layer;
@property (nonatomic, strong) CAShapeLayer *line4Layer;
@property (nonatomic, readonly) NSArray <CAShapeLayer *> *allLayers;
@end

@implementation DynamicButton

-(NSArray<CAShapeLayer *> *)allLayers {
    return @[self.line1Layer, self.line2Layer, self.line3Layer, self.line4Layer];
}

- (void)setup {
    _line1Layer = [CAShapeLayer layer];
    _line2Layer = [CAShapeLayer layer];
    _line3Layer = [CAShapeLayer layer];
    _line4Layer = [CAShapeLayer layer];
    
    [self setTitle:@"" forState:(UIControlStateNormal)];
    self.clipsToBounds = YES;
    _lineWidth = 2;
    _strokeColor = [UIColor blackColor];
    
    [self addTarget:self action:@selector(highlightAction:) forControlEvents:(UIControlEventTouchDown)];
    [self addTarget:self action:@selector(highlightAction:) forControlEvents:(UIControlEventTouchDragEnter)];
    [self addTarget:self action:@selector(unhighlightAction:) forControlEvents:(UIControlEventTouchDragExit)];
    [self addTarget:self action:@selector(unhighlightAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addTarget:self action:@selector(unhighlightAction:) forControlEvents:(UIControlEventTouchCancel)];
    
    for (CALayer *sublayer in self.allLayers) {
        [self.layer addSublayer:sublayer];
    }
    
    [self setupLayerPaths];
}

- (void)setupLayerPaths {
    for (CAShapeLayer *sublayer in self.allLayers) {
        sublayer.fillColor = [UIColor clearColor].CGColor;
        sublayer.anchorPoint = CGPointZero;
        sublayer.lineJoin = kCALineJoinRound;
        sublayer.lineCap = kCALineCapRound;
        sublayer.contentsScale = self.layer.contentsScale;
        sublayer.path = [UIBezierPath bezierPath].CGPath;
        sublayer.lineWidth = _lineWidth;
        sublayer.strokeColor = _strokeColor.CGColor;
    }
    
    [self setButtonStyle:_buttonStyle animated:NO];
}

- (instancetype)initWithStyle:(ButtonStyle)style {
    if (self = [super initWithFrame:(CGRect){{0, 0}, {44, 44}}]) {
        _buttonStyle = style;
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - overrides

-(void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:@"" forState:state];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width  = CGRectGetWidth(self.bounds) - (self.contentEdgeInsets.left + self.contentEdgeInsets.right);
    CGFloat height = CGRectGetHeight(self.bounds) - (self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
    
    intSize = MIN(width, height);
    intOffset = (CGPoint){(CGRectGetWidth(self.bounds) - intSize) / 2, (CGRectGetHeight(self.bounds) - intSize) / 2};
    [self setButtonStyle:_buttonStyle animated:NO];
}

#pragma mark - setters

-(void)setButtonStyle:(ButtonStyle)buttonStyle {
    [self setButtonStyle:buttonStyle animated:NO];
}

- (void)setButtonStyle:(ButtonStyle)buttonStyle animated:(BOOL)animated {
    if (_buttonStyle != buttonStyle) {
        _buttonStyle = buttonStyle;
        NSArray *paths = [PathHelper pathForButtonWithStyle:_buttonStyle size:intSize offset:intOffset lineWidth:_lineWidth];
        for (int x = 0; x < self.allLayers.count; x++) {
            if (animated) {
                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
                anim.fromValue = (__bridge id _Nullable)(self.allLayers[x].path);
                anim.toValue = paths[x];
                anim.duration = .25;
                
                [self.allLayers[x] addAnimation:anim forKey:@"animateLine"];
            } else {
                [self.allLayers[x] removeAllAnimations];
            }
            self.allLayers[x].path = (__bridge CGPathRef _Nullable)paths[x];
        }
    }
}

-(void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setupLayerPaths];
}

-(void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setupLayerPaths];
}

#pragma mark - actions

- (void)highlightAction:(id)sender {
    
}

- (void)unhighlightAction:(id)sender {
    
}

@end
