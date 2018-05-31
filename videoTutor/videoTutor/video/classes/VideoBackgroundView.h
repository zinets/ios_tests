//
//  VideoBackgroundView.h
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoBackgroundView : UIView
@property (nonatomic, strong) NSString *media;
- (void)play;
- (void)stop;
@end
