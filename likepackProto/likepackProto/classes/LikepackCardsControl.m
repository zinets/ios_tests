//
//  LikepackCardsControl.m
//  likepackProto
//
//  Created by Victor Zinets on 6/20/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "LikepackCardsControl.h"

@interface LikepackCardsControl ()
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation LikepackCardsControl

- (void)commonInit {
    self.backgroundColor = [UIColor brownColor];
    
    _bgImageView = [UIImageView new];
    _bgImageView.layer.borderWidth = 1;
    [self addSubview:_bgImageView];
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
    CGSize imageSize = self.bgImage.size;
    
    CGFloat arBounds = boundsSize.width / boundsSize.height;
    CGFloat arImage = imageSize.width / imageSize.height;
    
    if (arBounds < arImage) { // вписывание по ширине?
        CGFloat x = 0;
        CGFloat w = boundsSize.width;
        CGFloat h = w / arImage;
        CGFloat y = (boundsSize.height - h) / 2;
        CGRect frm = (CGRect){x, y, w, h};
        self.bgImageView.frame = frm;
    } else { // .. по высоте?
        CGFloat y = 0;
        CGFloat h = boundsSize.height;
        CGFloat w = h * arImage;
        CGFloat x = (boundsSize.width - w) / 2;
        CGRect frm = (CGRect){x, y, w, h};
        self.bgImageView.frame = frm;
    }
}

-(CGSize)intrinsicContentSize {
    return self.bgImageView.bounds.size;
}

#pragma mark setters -

-(void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    self.bgImageView.image = _bgImage;
    [self relayControls];
}

@end
