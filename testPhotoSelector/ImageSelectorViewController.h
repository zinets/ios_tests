//
//  ImageSelectorViewController.h
//
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageSourceType) {
    ImageSourceTypeLive,
    ImageSourceTypeCamera,
    ImageSourceTypeLibrary,
    ImageSourceTypeAlbums,
    ImageSourceTypeInstagram,
    ImageSourceTypeFacebook,
    
    ImageSourceTypeCount,
};

@protocol ImageSelectorDelegate <NSObject>
@required
/// надо ли в списке показывать источник этого типа?
- (BOOL)imageSelector:(id)sender supportsSourcetype:(ImageSourceType)sourceType;
/// текст для пункта списка для указанного типа
- (NSString *)imageSelector:(id)sender titleForSourceType:(ImageSourceType)sourceType;
/// закончили с результатом (возможно нулевым, т.е. юзер выбрал cancel)
- (void)imageSelector:(id)sender didFinishWithResult:(UIImage *)resultImage;
@optional
/// иконка для пункта списка для указанного типа
- (UIImage *)imageSelector:(id)sender iconForSourceType:(ImageSourceType)sourceType;
@end

@interface ImageSelectorViewController : UIViewController
@property (nonatomic, weak) id <ImageSelectorDelegate>delegate;
@end

