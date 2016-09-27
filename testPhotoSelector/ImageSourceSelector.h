//
//  ImageSourceSelector.h
//  Flirt
//
//  Created by Eugene Zhuk on 7/18/16.
//  Copyright © 2016 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageSourceSelector;
@protocol ImageSourceSelectorDelegate <NSObject>

- (void)imageSourceSelector:(ImageSourceSelector *)imageSourceSelector clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)imageSourceSelector:(ImageSourceSelector *)imageSourceSelector imageSelected:(UIImage *)image;
- (void)imageSourceSelectorCameraClicked:(ImageSourceSelector *)imageSourceSelector;

@end

@interface ImageSourceSelector : UIView
@property (nonatomic, weak) id <ImageSourceSelectorDelegate> delegate;
@property (nonatomic, weak) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSArray <NSString *> *otherButtonTitles;
@property (nonatomic, strong) NSArray <UIImage *> *otherButtonIcons;

@property (nonatomic, readonly) NSInteger cancelButtonIndex;
@property (nonatomic, readonly) BOOL visible;

- (void)showInView:(UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

@end
