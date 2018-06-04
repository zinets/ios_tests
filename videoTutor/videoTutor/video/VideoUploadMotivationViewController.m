//
//  VideoUploadMotivationViewController.m
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "VideoUploadMotivationViewController.h"

@interface VideoUploadMotivationViewController ()

@end

@implementation VideoUploadMotivationViewController

#pragma mark overrides -

-(BOOL)logoVisible {
    return NO;
}

-(NSString *)titleText {
    return @"Add a short VIDEO";
}

-(NSString *)descriptionText {
    return @"Video profiles get 10 times more attention";
}

-(NSString *)buttonTitleText {
    return @"Add a video";
}

-(NSString *)mediaFileName {
    return @"movie_bgr_postreg popup376x668.mp4";
}

@end
