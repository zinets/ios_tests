//
//  HexagonCell.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "HexagonCell.h"

@interface HexagonCell()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (nonatomic) CGFloat progress;

@property (nonatomic, strong) UIBezierPath *shapePath;
@end

@implementation HexagonCell  {
    CAShapeLayer *maskLayer;
    CAShapeLayer *progressLayer;
}

- (void)commonInit {
    progressLayer = [CAShapeLayer layer];
    progressLayer.fillColor = [UIColor clearColor].CGColor;

    progressLayer.strokeColor = [UIColor redColor].CGColor;
    progressLayer.strokeStart = 0;
    progressLayer.strokeEnd = 0;
    progressLayer.lineWidth = 5;
    [self.layer addSublayer:progressLayer];

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

- (void)dealloc {
    [self removeObserver];
}

#pragma mark layout -

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    _shapePath = nil;
    [self updateMask];
    [self updateProgressPath];
}

- (void)prepareForReuse {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.data = nil;
    
    [CATransaction commit];
    
}

-(UIBezierPath *)shapePath {
    if (!_shapePath) {
        _shapePath = [UIBezierPath bezierPath];
        CGFloat w = self.bounds.size.width / 2;
        CGFloat h = self.bounds.size.height / 2;
        [_shapePath moveToPoint:(CGPoint){w, 2 * h}]; // 0
        [_shapePath addLineToPoint:(CGPoint){w / 2, 2 * h}]; // 1
        [_shapePath addLineToPoint:(CGPoint){0, h}]; // 2
        [_shapePath addLineToPoint:(CGPoint){w / 2, 0}]; // 3
        [_shapePath addLineToPoint:(CGPoint){3 * w / 2, 0}]; // 4
        [_shapePath addLineToPoint:(CGPoint){2 * w, h}]; // 5
        [_shapePath addLineToPoint:(CGPoint){3 * w / 2, 2 * h}]; // 6
        [_shapePath closePath]; // 0
    }
    return _shapePath;
}

-(void)updateMask {
    CABasicAnimation *animation = [CABasicAnimation animation];
    [maskLayer addAnimation:animation forKey:@"path animation"];
    maskLayer.path = self.shapePath.CGPath;
}

- (void)updateProgressPath {
    progressLayer.frame = self.bounds;
    progressLayer.path = self.shapePath.CGPath;
}

#pragma mark touches -

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if ([self.shapePath containsPoint:point]) {
        return [super hitTest:point withEvent:event];
    } else {
        return nil;
    }
}

#pragma mark public -

- (void)setData:(HexagonCellData *)data {
    self.label.text = data.avatarUrl;
    _avatar.image = [UIImage imageNamed:data.avatarUrl];
    self.progress = data.progress;

    [self addObserver:data];
}

- (void)setProgress:(CGFloat)progress {
    _progress = MAX(0, MIN(1, progress));

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1;
    animation.fromValue = @(progressLayer.strokeEnd);
    animation.toValue = @(_progress);

    progressLayer.strokeEnd = _progress;

    [progressLayer addAnimation:animation forKey:@"a@"];


}

#pragma mark observing -

- (void)dataChanged:(NSNotification *)notification {
    self.progress = ((HexagonCellData *)notification.object).progress;
}

-(void)addObserver:(id)data {
    [self removeObserver];
    if (data) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChanged:) name:HexCellDataChanged object:data];
    }
}

-(void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
