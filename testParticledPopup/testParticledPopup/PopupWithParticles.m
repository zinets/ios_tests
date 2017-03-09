//
// Created by Zinets Victor on 3/9/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

#import "PopupWithParticles.h"

#import "UIColor+MUIColor.h"
#import "ParticlesView.h"

#pragma mark -

@interface PopupWithParticles()
@property (nonatomic, strong) UIColor *initialBgColor;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) ParticlesView *particlesView;
@end

#pragma mark - implementation

@implementation PopupWithParticles

- (void)initControl {
    self.backgroundColor = [UIColor colorWithHex:0x0291f3];
    self.initialBgColor = [[UIColor colorWithHex:0x0291f3] colorWithAlphaComponent:0];

    [self addSubview:self.particlesView];
    [self addSubview:self.contentView];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)onTap {
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initControl];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initControl];
    }

    return self;
}


#pragma mark - animation

#define DURATION_1 1.
#define DURATION_2 1.

- (void)startAnimation {
    UIColor *finalBgColor = self.backgroundColor;
    self.backgroundColor = self.initialBgColor;
    self.contentView.transform = CGAffineTransformMakeTranslation(0, self.viewForFirstBaselineLayout.bounds.size.height);
    self.particlesView.hidden = YES;
    [UIView animateWithDuration:DURATION_1 animations:^{
        self.backgroundColor = finalBgColor;
        self.contentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.particlesView.transform = CGAffineTransformMakeScale(self.contentView.bounds.size.width / self.particlesView.bounds.size.width, self.contentView.bounds.size.height / self.particlesView.bounds.size.height);
        self.particlesView.hidden = NO;
        [UIView animateWithDuration:DURATION_2 animations:^{
            self.particlesView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {

        }];
    }];
}

#pragma mark - overrides

- (void)didMoveToSuperview {
    [self startAnimation];
}

#pragma mark - getters/setters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:(CGRect){{20, 100}, {self.bounds.size.width - 40, 360}}];
        _contentView.layer.cornerRadius = 4;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (ParticlesView *)particlesView {
    if (!_particlesView) {
        // фрейм - квадрат?
        _particlesView = [[ParticlesView alloc] initWithFrame:self.bounds];
        _particlesView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.4];
        _particlesView.particleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    }
    return _particlesView;
}

@end