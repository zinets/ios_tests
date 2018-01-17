//
//  InputViewController.h
//  testConversations
//
//  Created by Zinets Viktor on 1/15/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol InputViewControllerDelegate <NSObject>
- (void)inputView:(id)sender selectedMediaToSend:(PHAsset *)asset;
- (void)inputView:(id)sender enteredTextToSend:(NSString *)text;

- (void)inputViewWantsToOpenCamera:(id)sender;
- (void)inputViewWantsToOpenGallery:(id)sender;
@end

@interface InputViewController : UIViewController
@property (nonatomic) BOOL cameraButtonVisible;
@property (nonatomic) BOOL galleryButtonVisible;

@property (nonatomic, strong) NSString *textPlaceholder;

@property (nonatomic, weak) id <InputViewControllerDelegate> delegate;
@end
