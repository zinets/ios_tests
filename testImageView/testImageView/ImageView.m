//
//  ImageView.m
//  testImageView
//
//  Created by Zinets Victor on 2/17/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import "ImageView.h"

@interface ImageView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *imageSite;
@end

@implementation ImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initComponents];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    self.clipsToBounds = YES;
    self.delegate = self;
    self.maximumZoomScale = 3;
    
    [self addSubview:self.imageSite];
}

- (void)relayImage {
    CGSize imageSize = _image.size;
    CGFloat imageAR = imageSize.width / imageSize.height;
    
    CGSize thisSize = self.frame.size;
    CGFloat thisAR = thisSize.width / thisSize.height;
    CGRect rectToFit = self.bounds;
    if (thisAR > imageAR) {
        CGFloat k = thisSize.width / imageSize.width;
        rectToFit = (CGRect){{0, 0}, {thisSize.width, imageSize.height * k}};
    } else if (thisAR < imageAR) {
        CGFloat k = imageSize.height / thisSize.height;
        CGFloat w = imageSize.width / k;
        rectToFit = (CGRect){{(thisSize.width - w) / 2, 0}, {w, thisSize.height}};
    } else {
        
    }
    self.contentOffset = (CGPoint){-rectToFit.origin.x, -rectToFit.origin.y};
    self.contentSize = rectToFit.size;
    
    rectToFit.origin = CGPointZero;
    self.imageSite.frame = rectToFit;
    self.imageSite.image = _image;
}

#pragma mark - getters

-(UIImageView *)imageSite {
    if (!_imageSite) {
        _imageSite = [UIImageView new];
    }
    return _imageSite;
}

#pragma mark -

-(void)setImage:(UIImage *)image {
    _image = image;

    CATransition *a = [CATransition animation];
    a.type = kCATransitionFade;
    [self.layer addAnimation:a forKey:@"imageLoading"];
    
    [self relayImage];
}

-(void)setFrame:(CGRect)frame {
    if (_image) {
        [UIView animateWithDuration:0.3 animations:^{
            [super setFrame:frame];
            [self relayImage];
        }];
    } else {
        [super setFrame:frame];
    }
}

#pragma mark - scroller

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.zoomEnabled) {
        return self.imageSite;
    } else {
        return nil;
    }
}

@end
