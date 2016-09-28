//
//  FlirtTakePhotoControllerViewController.h
//
//  Created by Eugene Zhuk on 27.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TakePhotoControllerViewController;

@protocol TakePhotoControllerViewControllerDelegate <NSObject>
@optional
- (void)takePhotoController:(TakePhotoControllerViewController *)controller didFinishPickingImage:(UIImage *)image;
- (void)takePhotoControllerDidCancel:(TakePhotoControllerViewController *)controller;
@end

@interface TakePhotoControllerViewController : UIViewController
@property (nonatomic, weak) id<TakePhotoControllerViewControllerDelegate> delegate;
@end
