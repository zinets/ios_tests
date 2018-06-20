//
//  LikepackCardsControl.m
//  likepackProto
//
//  Created by Victor Zinets on 6/20/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "LikepackCardsControl.h"

@interface LikepackCardsControl ()
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) CALayer *frameMaskLayer;
@property (nonatomic, strong) UIImageView *frameImageView;
@property (nonatomic, strong) UIImageView *ribbonImageView;
@end

@implementation LikepackCardsControl

- (void)commonInit {
    self.backgroundColor = [UIColor brownColor];
    
    _photoImageView = [UIImageView new];
    _frameMaskLayer = [CALayer layer];
    _photoImageView.layer.mask = _frameMaskLayer;
    [self addSubview:_photoImageView];
    
    _frameImageView = [UIImageView new];
    [self addSubview:_frameImageView];
    
    _ribbonImageView = [UIImageView new];
    _frameImageView.layer.borderWidth = 1;
    [self addSubview:_ribbonImageView];
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
        CGFloat y = 195 * h / 450;
        frm = (CGRect){x, y, w, w / arRibbon};
        self.ribbonImageView.frame = frm;
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

@end
