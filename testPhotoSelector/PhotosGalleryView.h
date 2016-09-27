//
//  PhotosGalleryView.h
//  Flirt
//
//  Created by Eugene Zhuk on 7/18/16.
//  Copyright © 2016 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotosGalleryView;
@protocol PhotosGalleryViewDelegate <NSObject>

- (void)photosGalleryView:(PhotosGalleryView *)imageSourceSelector imageSelected:(UIImage *)image;
- (void)photosGalleryViewCameraClicked:(PhotosGalleryView *)imageSourceSelector;

@end

@interface PhotosGalleryView : UIView
@property (nonatomic, weak) id <PhotosGalleryViewDelegate> delegate;
- (void)setCameraSessionStarted:(BOOL)start;
@end
