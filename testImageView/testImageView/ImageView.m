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
    
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 3;
    self.bounces = YES;
    
    [self addSubview:self.imageSite];
    
#ifdef DEBUG
    self.layer.borderColor = [UIColor yellowColor].CGColor;
    self.layer.borderWidth = 2;
#endif
}

- (void)relayImage {
    if (_image) {
        CGSize imageSize = _image.size;
        CGFloat imageAR = imageSize.width / imageSize.height;
        
        CGSize thisSize = self.frame.size;
        CGFloat thisAR = thisSize.width / thisSize.height;
        CGRect rectToFit = self.bounds;
        
        if (self.zoomEnabled) {
            if (imageAR > thisAR) {
                rectToFit.origin.x = 0;
                rectToFit.size.width = thisSize.width;
                CGFloat k = thisSize.width / imageSize.width;
                CGFloat h = imageSize.height * k;
                rectToFit.size.height = h;
                rectToFit.origin.y = (thisSize.height - h) / 2;
            } else {
                rectToFit.size.height = thisSize.height;
                rectToFit.origin.y = 0;
                CGFloat k = thisSize.height / imageSize.height;
                CGFloat w = imageSize.width * k;
                rectToFit.size.width = w;
                rectToFit.origin.x = (thisSize.width - w) / 2;
            }
            self.contentSize = rectToFit.size;
        } else {
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
        }
        self.imageSite.frame = rectToFit;
        self.imageSite.image = _image;
    }
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

-(void)setZoomEnabled:(BOOL)zoomEnabled {
    _zoomEnabled = zoomEnabled;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageSite.transform = CGAffineTransformIdentity;
        [self relayImage];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - scroller

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGRect imageSiteFrame = self.imageSite.frame;
    CGPoint pt = scrollView.contentOffset;
    
    if (self.imageSite.bounds.size.height < self.bounds.size.height) {
        // пока размер меньше размера скроллера - при зуме орижин вью, которое зумим не меняется - меняю его вручную
        imageSiteFrame.origin.y = MAX(0, (self.frame.size.height - imageSiteFrame.size.height) / 2);
    } else {
        // если размер вью, которое зумим, больше - включается скрол за счет зума
        imageSiteFrame.origin.y = 0;
    }
    
    if (self.imageSite.bounds.size.width < self.bounds.size.width) {
        imageSiteFrame.origin.x = MAX(0, (self.frame.size.width - imageSiteFrame.size.width) / 2);
    } else {
        imageSiteFrame.origin.x = 0;
    }
    
    self.imageSite.frame = imageSiteFrame;
    self.contentOffset = pt;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.zoomEnabled) {
        return self.imageSite;
    } else {
        return nil;
    }
}

@end
