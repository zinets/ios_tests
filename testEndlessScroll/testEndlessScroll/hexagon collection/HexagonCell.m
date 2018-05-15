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
@end

@implementation HexagonCell  {
    UIBezierPath *maskPath;
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


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    [self updateMask];
    [self updateProgressPath];
}

- (void)prepareForReuse {
    self.data = nil;
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

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    if ([maskPath containsPoint:point]) {
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
    progressLayer.strokeEnd = progress;
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
