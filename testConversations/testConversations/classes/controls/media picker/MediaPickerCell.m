//
//  MediaPickerCell.m
//  testConversations
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "MediaPickerCell.h"

@implementation MediaPickerCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tolka.jpg"]];
        iv.frame = self.bounds;
        iv.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        iv.contentMode = UIViewContentModeScaleToFill;
        iv.clipsToBounds = YES;
        
        [self.contentView addSubview:iv];
    }
    return self;
}

@end
