//
//  InputViewController.h
//  testConversations
//
//  Created by Zinets Viktor on 1/15/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    InputViewButtonCamera,
    InputViewButtonGallery,
    InputViewButtonPostMessage,
} InputViewButton;

@protocol InputViewControllerDelegate <NSObject>
- (void)inputView:(id)sender didSelectButton:(InputViewButton)buttonType;
@end

@interface InputViewController : UIViewController
@property (nonatomic) BOOL cameraButtonVisible;
@property (nonatomic) BOOL galleryButtonVisible;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, weak) id <InputViewControllerDelegate> delegate;
@end
