//
//  LikepackCardsControl.m
//  likepackProto
//
//  Created by Victor Zinets on 6/20/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "LikepackCardsControl.h"
#import "CountdownControl.h"

@interface LikepackCardsControl ()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) CALayer *frameMaskLayer;
@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) UIImageView *ribbonImageView;
@property (nonatomic, strong) UILabel *ribbonTitleLabel;
@property (nonatomic, strong) UILabel *ribbonTextLabel;
@property (nonatomic, strong) CountdownControl *countdownControl;
@end

@implementation LikepackCardsControl

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    _photoImageView = [UIImageView new];
    _frameMaskLayer = [CALayer layer];
    _photoImageView.layer.mask = _frameMaskLayer;
    [self addSubview:_photoImageView];
    
    _frameImageView = [UIImageView new];
    [self addSubview:_frameImageView];
    
    _ribbonImageView = [UIImageView new];
    [self addSubview:_ribbonImageView];
    
    _ribbonTitleLabel = [UILabel new];
    _ribbonTitleLabel.backgroundColor = [UIColor clearColor];
    _ribbonTitleLabel.font = [UIFont systemFontOfSize:16 weight:(UIFontWeightRegular)];
    _ribbonTitleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    _ribbonTitleLabel.textAlignment = NSTextAlignmentCenter;
    _ribbonTitleLabel.text = @"Ribbon title";
    [self addSubview:_ribbonTitleLabel];
    
    _ribbonTextLabel = [UILabel new];
    _ribbonTextLabel.backgroundColor = [UIColor clearColor];
    _ribbonTextLabel.font = [UIFont systemFontOfSize:24 weight:(UIFontWeightBold)];
    _ribbonTextLabel.textColor = [UIColor whiteColor];
    _ribbonTextLabel.textAlignment = NSTextAlignmentCenter;
    _ribbonTextLabel.text = @"Ribbon text";
    [self addSubview:_ribbonTextLabel];
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
    [self relayControls];
}

-(void)relayControls {
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self.frameImage.size;
    
    CGFloat arBounds = boundsSize.width / boundsSize.height;
    CGFloat arImage = imageSize.width / imageSize.height;
    CGFloat x, w, h;
    CGRect frm;
    if (arBounds < arImage) { // вписывание по ширине?
        x = 0;
        w = boundsSize.width;
        h = w / arImage;
        CGFloat y = (boundsSize.height - h) / 2;
        frm = (CGRect){x, y, w, h};
        self.frameImageView.frame = frm;
    } else { // .. по высоте?
        CGFloat y = 0;
        h = boundsSize.height;
        w = h * arImage;
        x = (boundsSize.width - w) / 2;
        frm = (CGRect){x, y, w, h};
        self.frameImageView.frame = frm;
    }
    
    self.photoImageView.frame = self.frameImageView.frame;
    self.frameMaskLayer.frame = self.photoImageView.bounds;
    
    // ribbon
    if (self.ribbonImage) {
        CGSize ribbonSize = self.ribbonImage.size;
        CGFloat arRibbon = ribbonSize.width / ribbonSize.height;
        CGFloat y = 195 * h / 433; // без магии никуда.. цыфры выверены из дизайна
        frm = (CGRect){x, y, w, w / arRibbon};
        self.ribbonImageView.frame = frm;
        
        y = 314 * h / 433;
        frm = (CGRect){x + 20, y, w - 2 * 20, 20};
//        self.ribbonTitleLabel.frame = frm;
        frm = (CGRect){x + 20, y, w - 2 * 20, 30};
        self.ribbonTextLabel.frame = frm;
    }
}

-(CGSize)intrinsicContentSize {
    return self.frameImageView.bounds.size;
}

#pragma mark setters -

-(void)setFrameImage:(UIImage *)bgImage {
    _frameImage = bgImage;
    self.frameImageView.image = _frameImage;
    [self relayControls];
}

-(void)setFrameMaskImage:(UIImage *)frameMaskImage {
    _frameMaskImage = frameMaskImage;
    self.frameMaskLayer.contents = (id)_frameMaskImage.CGImage;
}

-(void)setImage:(UIImage *)image {
    _image = image;
    self.photoImageView.image = _image;
}

-(void)setRibbonImage:(UIImage *)ribbonImage {
    _ribbonImage = ribbonImage;
    self.ribbonImageView.image = _ribbonImage;
    [self relayControls];
}

-(void)setRibbonTitle:(NSString *)ribbonTitle {
    _ribbonTitle = ribbonTitle;
    self.ribbonTitleLabel.text = _ribbonTitle;
}

-(void)setRibbonText:(NSString *)ribbonText {
    _ribbonText = ribbonText;
    self.ribbonTextLabel.text = _ribbonText;
}

-(void)setIsCountdownVisible:(BOOL)isCountdownVisible {
    _isCountdownVisible = isCountdownVisible;
    if (_isCountdownVisible && !_countdownControl) {
        _countdownControl = [CountdownControl new];
        [_countdownControl sizeToFit];
        [self addSubview:_countdownControl];
        
        _countdownControl.angle = -0.05;
        _countdownControl.digitColor = [UIColor whiteColor];
        
        _countdownControl.center = (CGPoint){self.bounds.size.width - _countdownControl.bounds.size.width / 2 - 50, 38};
        _countdownControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    _countdownControl.hidden = !_isCountdownVisible;
}

-(void)setCountdownRemainingTime:(NSTimeInterval)countdownRemainingTime {
    _countdownRemainingTime = countdownRemainingTime;
    _countdownControl.remainingTime = _countdownRemainingTime;
}

@end
