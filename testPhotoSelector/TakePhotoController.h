//
//  FlirtTakePhotoController.h
//
//  Created by Eugene Zhuk on 27.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TakePhotoController;

@protocol TakePhotoControllerDelegate <NSObject>
@optional
- (void)takePhotoController:(TakePhotoController *)controller didFinishPickingImage:(UIImage *)image;
- (void)takePhotoControllerDidCancel:(TakePhotoController *)controller;
@end

@interface TakePhotoController : UIViewController
@property (nonatomic, weak) id<TakePhotoControllerDelegate> delegate;
@end
