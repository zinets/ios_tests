//
//  PhotoFromInternetCell.m
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PhotoFromInternetCell.h"
@import TNURLImageView;

@interface PhotoFromInternetCell()
@property (weak, nonatomic) IBOutlet TNImageView *imageView;
@end

@implementation PhotoFromInternetCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.contentModeAnimationDuration = 0.25;
}

-(void)prepareForReuse {
    self.imageView.image = nil;
}

-(void)setData:(PhotoFromInternet *)data {
    self.imageView.allowLoadingAnimation = NO;//self.imageView.image == nil;

    [self.imageView loadImageFromUrl:data.url];
}

-(UIImage *)image {
    return self.imageView.image;
}

-(UIViewContentMode)imageContentMode {
    return self.imageView.contentMode;
}

-(void)setImageContentMode:(UIViewContentMode)imageContentMode {
    self.imageView.contentMode = imageContentMode;
}

@end
