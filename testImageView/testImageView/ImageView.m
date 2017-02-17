//
//  ImageView.m
//  testImageView
//
//  Created by Zinets Victor on 2/17/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import "ImageView.h"

@interface ImageView ()
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
    
    self.imageSite = [UIImageView new];
//    self.imageSite.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.imageSite];
}

-(void)setImage:(UIImage *)image {
    _image = image;
    
    CGSize imageSize = image.size;
    CGFloat imageAR = imageSize.width / imageSize.height;
    
    CGSize thisSize = self.frame.size;
    CGFloat thisAR = thisSize.width / thisSize.height;
    
    if (thisAR > 1) { // landscape view
        if (thisAR > imageAR) {
            CGFloat k = thisSize.width / imageSize.width;
            CGRect rectToFit = (CGRect){{0, 0}, {thisSize.width, imageSize.height * k}};
            self.imageSite.frame = rectToFit;
        } else if (thisAR < imageAR) {
            CGFloat k = imageSize.height / thisSize.height;
            CGFloat w = imageSize.width / k;
            CGRect rectToFit = (CGRect){{(thisSize.width - w) / 2, 0}, {w, thisSize.height}};
            self.imageSite.frame = rectToFit;
        } else {
            self.imageSite.frame = self.bounds;            
        }
    } else if (thisAR < 1) { // portrait view
        if (thisAR > imageAR) {
            CGFloat k = thisSize.width / imageSize.width;
            CGRect rectToFit = (CGRect){{0, 0}, {thisSize.width, imageSize.height * k}};
            self.imageSite.frame = rectToFit;
        } else if (thisAR < imageAR) {
            CGFloat k = imageSize.height / thisSize.height;
            CGFloat w = imageSize.width / k;
            CGRect rectToFit = (CGRect){{(thisSize.width - w) / 2, 0}, {w, thisSize.height}};
            self.imageSite.frame = rectToFit;
        } else {
            self.imageSite.frame = self.bounds;
        }
    } else { // square
        if (thisAR > imageAR) {
            CGFloat k = thisSize.width / imageSize.width;
            CGRect rectToFit = (CGRect){{0, 0}, {thisSize.width, imageSize.height * k}};
            self.imageSite.frame = rectToFit;
        } else if (thisAR < imageAR) {
            CGFloat k = imageSize.height / thisSize.height;
            CGFloat w = imageSize.width / k;
            CGRect rectToFit = (CGRect){{(thisSize.width - w) / 2, 0}, {w, thisSize.height}};
            self.imageSite.frame = rectToFit;
        } else {
            self.imageSite.frame = self.bounds;
        }
    }
    
    self.imageSite.image = _image;
}

@end
