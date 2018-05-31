//
//  GradientButton.m
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "GradientButton.h"

@interface GradientButton()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation GradientButton

- (void)commonInit {
    [self.layer addSublayer:self.gradientLayer];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self updateGradientLayer];
}

#pragma mark setters -

- (void)updateGradientLayer {
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = YES;
    
    self.gradientLayer.frame = self.bounds;
    NSMutableArray *colors = [@[] mutableCopy]; {
        if (self.endGradientColor) {
            [colors addObject:(id)self.endGradientColor.CGColor];
        }
        if (self.startGradientColor) {
            [colors addObject:(id)self.startGradientColor.CGColor];
        }
        
        if (colors.count) {
            self.gradientLayer.colors = [colors copy];
        }
    }
}

-(CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        self.gradientDirection = ButtonGradientDirectionHorizontal;
    }
    return _gradientLayer;
}

-(void)setStartGradientColor:(UIColor *)startGradientColor {
    _startGradientColor = startGradientColor;
    [self updateGradientLayer];
}

-(void)setEndGradientColor:(UIColor *)endGradientColor {
    _endGradientColor = endGradientColor;
    [self updateGradientLayer];
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self updateGradientLayer];
}

-(void)setGradientDirection:(ButtonGradientDirection)gradientDirection {
    _gradientDirection = gradientDirection;
    switch (_gradientDirection) {
        case ButtonGradientDirectionDiagonal:
            _gradientLayer.startPoint = (CGPoint){0, 0};
            _gradientLayer.endPoint = (CGPoint){1, 1};
            break;
        case ButtonGradientDirectionVertical:
            _gradientLayer.startPoint = (CGPoint){0.5, 0};
            _gradientLayer.endPoint = (CGPoint){0.5, 1};
            break;
        case ButtonGradientDirectionHorizontal:
            _gradientLayer.startPoint = (CGPoint){0, 0.5};
            _gradientLayer.endPoint = (CGPoint){1, 0.5};
            break;
    }
}

@end
