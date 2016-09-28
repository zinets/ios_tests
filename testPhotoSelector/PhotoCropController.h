//
//  FlirtPhotoCropper.h
//
//  Created by Zinetz Victor on 01.11.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCropController : UIViewController
@property (nonatomic, strong) UIImage * imageToCrop;
@property (nonatomic, copy) void (^ completionBlock)(UIImage * image);
@end
