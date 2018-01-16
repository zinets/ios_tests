//
//  GalleryButton.h
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GalleryButtonDelegate <NSObject>
- (void)galleryButtonWantsShowFullLibrary:(id)sender;
- (void)galleryButton:(id)sender didSelectImage:(UIImage *)image;
// todo а видос
@end

// кнопочка, которая в выделеном состоянии показывает селектор фото из "камера рола" в кастомной "клавиатуре"
@interface GalleryButton : UIButton
@property (nonatomic, weak) id <GalleryButtonDelegate> delegate;
@end
