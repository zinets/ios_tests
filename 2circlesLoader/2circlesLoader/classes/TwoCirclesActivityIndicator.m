//
// Created by Victor Zinets on 7/10/18.
// Copyright (c) 2018 Dolboyob Inc. All rights reserved.
//

#import "TwoCirclesActivityIndicator.h"

@interface TwoCirclesActivityIndicator()
@property (nonatomic, strong) CALayer *layer1;
@end

@implementation TwoCirclesActivityIndicator {

}

#pragma mark getters -

- (CALayer *)layer1 {
    if (!_layer1) {
        _layer1 = [CALayer new];
        CGRect frame = self.bounds;
        _layer1.frame = frame;
        _layer1.backgroundColor = [UIColor yellowColor].CGColor;
    }

    return _layer1;
}

#pragma mark public -

- (void)commonInit {
    [self.layer addSublayer:self.layer1];
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


- (void)startAnimation {
    CABasicAnimation *rotating = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotating.duration = 1.5;
    rotating.fromValue = @0;
    rotating.toValue = @(M_PI * 2);
    rotating.repeatCount = HUGE_VAL;
    [self.layer1 addAnimation:rotating forKey:@"rotating1"];
}

- (void)stopAnimation {

}

@end