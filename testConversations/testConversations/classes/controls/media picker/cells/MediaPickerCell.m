//
//  MediaPickerCell.m
//  testConversations
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "MediaPickerCell.h"

@implementation MediaPickerCell {
    UIImageView *iv;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        iv = [[UIImageView alloc] initWithFrame:self.bounds];
        iv.frame = self.bounds;
        iv.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        
        [self.contentView addSubview:iv];
    }
    return self;
}

-(void)setImage:(UIImage *)image {
    iv.image = image;
}

@end
