//
//  BlindActivityIndicator2.m
//  blindActivityIndicator
//
//  Created by Victor Zinets on 11/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "BlindActivityIndicator2.h"

@interface BlindActivityIndicator2 () {
    
}
@property (nonatomic, strong) CAGradientLayer *dotLayer;
@property (nonatomic, strong) CAReplicatorLayer *replicantLayer;
@end

@implementation BlindActivityIndicator2

- (void)commonInit {
    _updateTime = 3.5;
    _radius = 25;
    _dotRadius = 8;
    _numberOfDots = 7;
    
    [self.layer addSublayer:self.replicantLayer];
    
    [self updateDots];
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
    self.replicantLayer.position = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
}

#pragma mark - layout

-(CGSize)intrinsicContentSize {
    return self.replicantLayer.bounds.size;
}

#pragma mark - internal

- (void)updateDots {
    CGFloat w = (_radius + _dotRadius) * 2;
    self.replicantLayer.frame = (CGRect){CGPointZero, (CGSize){w, w}};
    self.dotLayer.position = (CGPoint){w / 2 + _radius, w / 2};
    
    [self invalidateIntrinsicContentSize];
}

- (void)updateReplicator {
    self.replicantLayer.instanceCount = _numberOfDots;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, (CGFloat)(2 * M_PI / _numberOfDots), 0, 0, 1);
    self.replicantLayer.instanceTransform = transform;
    self.replicantLayer.instanceDelay = (CGFloat)(_updateTime / _numberOfDots);
}

- (NSArray *)cgColorsFrom:(NSArray <UIColor *> *)colors {
    NSMutableArray *arr = [NSMutableArray new];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:(id)obj.CGColor];
    }];
    return arr;
}

#pragma mark - getters

-(NSMutableArray *)activeColors {
    if (!_activeColors) {
        _activeColors = [NSMutableArray new];
        [_activeColors addObject:[UIColor redColor]];
        [_activeColors addObject:[UIColor yellowColor]];
    }
    return _activeColors;
}

-(NSMutableArray *)inactiveColors {
    if (!_inactiveColors) {
        _inactiveColors = [NSMutableArray new];
        [_inactiveColors addObject:[UIColor grayColor]];
        [_inactiveColors addObject:[UIColor grayColor]];
    }
    return _inactiveColors;
}

-(CAReplicatorLayer *)replicantLayer {
    if (!_replicantLayer) {
        _replicantLayer = [CAReplicatorLayer new];
        CGFloat w = (_radius + _dotRadius) * 2;
        _replicantLayer.frame = (CGRect){0, 0, w, w};
        self.dotLayer.position = (CGPoint){w / 2 + _radius + _dotRadius, w / 2};
        [_replicantLayer addSublayer:self.dotLayer];
        
        _replicantLayer.instanceCount = _numberOfDots;
        
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, (CGFloat)(2 * M_PI / _numberOfDots), 0, 0, 1);
        _replicantLayer.instanceTransform = transform;
        
        _replicantLayer.instanceDelay = (CGFloat)(_updateTime / _numberOfDots);
    }
    return _replicantLayer;
}

-(void)setDotRadius:(CGFloat)dotRadius {
    _dotRadius = MAX(5, dotRadius);
    CGRect frame = self.dotLayer.frame;
    frame.size.height = frame.size.width = 2 * _dotRadius;
    self.dotLayer.frame = frame;
    self.dotLayer.cornerRadius = _dotRadius;
    [self updateDots];
}

-(void)setRadius:(CGFloat)radius {
    _radius = MAX(15, radius);
    [self updateDots];
}

-(void)setNumberOfDots:(NSInteger)numberOfDots {
    _numberOfDots = MAX(5, numberOfDots);
    [self updateReplicator];
    [self updateDots];
}

-(CAGradientLayer *)dotLayer {
    if (!_dotLayer) {
        _dotLayer = [CAGradientLayer new];
        _dotLayer.frame = (CGRect){0, 0, self.dotRadius * 2, self.dotRadius * 2};
        _dotLayer.cornerRadius = self.dotRadius;
        _dotLayer.colors = [self cgColorsFrom:self.inactiveColors];
        
//        _dotLayer.borderWidth = 1;
//        _dotLayer.borderColor = [UIColor redColor].CGColor;
    }
    return _dotLayer;
}

#pragma mark - animation

- (void)startAnimation {
    if (self.dotLayer.animationKeys.count > 0) { return; }
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup new];
    animationGroup.duration = self.updateTime;
    animationGroup.repeatCount = HUGE;
    
    CAKeyframeAnimation *colorAnimation = [CAKeyframeAnimation animationWithKeyPath:@"colors"];
    colorAnimation.keyTimes = @[ @0, @0.25, @0.5, @0.75, @1 ];
    NSArray *inactive = [self cgColorsFrom:self.inactiveColors];
    NSArray *active = [self cgColorsFrom:self.activeColors];
    colorAnimation.values = @[ inactive, active, active, inactive ];
    colorAnimation.duration = _updateTime / _numberOfDots;
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    animationGroup.animations = @[ colorAnimation ];
    
    [self.dotLayer addAnimation:animationGroup forKey:@"circling"];
}

- (void)stopAnimation {
    [self.dotLayer removeAllAnimations];
}

@end
