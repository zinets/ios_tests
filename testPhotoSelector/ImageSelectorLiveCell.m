//
//  ImageSelectorLiveCell.m
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ImageSelectorLiveCell.h"
#import "PhotosGalleryView.h"
#import "PhotoGalleryAssetsManager.h"

@interface ImageSelectorLiveCell() <PhotosGalleryViewDelegate>
@end

@implementation ImageSelectorLiveCell {
    PhotosGalleryView *_liveView;
}

#define SIDE_INSET 4.
#define LIVE_CELL_HEIGHT (88 + SIDE_INSET * 2)

+ (CGFloat)cellHeight {
    return LIVE_CELL_HEIGHT;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _liveView = [[PhotosGalleryView alloc] initWithFrame:(CGRect){{SIDE_INSET, SIDE_INSET}, {self.contentView.bounds.size.width - 2 * SIDE_INSET, LIVE_CELL_HEIGHT}}];
        _liveView.delegate = self;
        _liveView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [PhotoGalleryAssetsManager checkCameraAuthorizationStatusWithCompletion:^(BOOL granted) {            
            [_liveView setCameraSessionStarted:granted];
        }];
        [self.contentView addSubview:_liveView];
    }
    return self;
}

- (void)photosGalleryView:(PhotosGalleryView *)imageSourceSelector imageSelected:(UIImage *)image {
    if (self.delegate) {
        [self.delegate cell:self didSelectImage:image];
    }
}

- (void)photosGalleryViewCameraClicked:(PhotosGalleryView *)imageSourceSelector {
    if (self.delegate) {
        [self.delegate cell:self didSelectImage:nil];
    }
}

@end
