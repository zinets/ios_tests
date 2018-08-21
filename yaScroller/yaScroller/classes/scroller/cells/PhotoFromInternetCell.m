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
@property (weak, nonatomic) IBOutlet UILabel *index;


@end

@implementation PhotoFromInternetCell

-(void)awakeFromNib {
    UITapGestureRecognizer *r = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.imageView addGestureRecognizer:r];
    
    self.imageView.contentModeAnimationDuration = 0.75;
}

-(void)setData:(PhotoFromInternet *)data {
    self.imageView.allowLoadingAnimation = NO;//self.imageView.image == nil;

    [self.imageView loadImageFromUrl:data.url];
}

-(void)setFs:(BOOL)fs {
//    self.imageView.contentMode = fs ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
}

-(void)setItemIndex:(NSInteger)itemIndex {
    self.index.text = [@(itemIndex) stringValue];
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

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    if (self.imageView.contentMode == UIViewContentModeScaleAspectFit) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

@end
