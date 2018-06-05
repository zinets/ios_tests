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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setData:(PhotoFromInternet *)data {
    [self.imageView loadImageFromUrl:data.url];
}

-(void)setFs:(BOOL)fs {
    self.imageView.contentMode = fs ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
}

@end
