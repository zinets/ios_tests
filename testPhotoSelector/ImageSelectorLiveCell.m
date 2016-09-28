//
//  ImageSelectorLiveCell.m
//  testPhotoSelector
//
//  Created by Zinets Victor on 9/28/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ImageSelectorLiveCell.h"
#import "PhotosGalleryView.h"

@implementation ImageSelectorLiveCell {
    PhotosGalleryView *_liveView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _liveView = [[PhotosGalleryView alloc] initWithFrame:(CGRect){{4, 4}, {self.contentView.bounds.size.width - 8, 88 + 4 * 2}}];
//        _liveView.delegate = self;
        _liveView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_liveView];
    }
    return self;
}

@end
