//
//  VideoTutorialViewController.h
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VideoTutorialActionClose,
    VideoTutorialActionDoAction,
} VideoTutorialAction;

@protocol VideoTutorialViewControllerDelegate <NSObject>
- (void)videoTutorial:(UIViewController *)sender didSelectAction:(VideoTutorialAction)action;
@end

@interface BaseVideoTutorialViewController : UIViewController
@property (nonatomic, weak) id <VideoTutorialViewControllerDelegate> delegate;
@end
