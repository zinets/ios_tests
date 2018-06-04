//
//  VideoTutorialViewController.m
//  videoTutor
//
//  Created by Victor Zinets on 5/31/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "OnboardingVideoTutorialViewController.h"

@interface OnboardingVideoTutorialViewController ()

@end

@implementation OnboardingVideoTutorialViewController

#pragma mark overrides -

-(BOOL)logoVisible {
    return YES;
}

-(NSString *)titleText {
    return @"Get ready for a VIDEO dating!";
}

-(NSString *)descriptionText {
    return @"Watch how people look like in real life";
}

-(NSString *)buttonTitleText {
    return @"Let’s create my video!";
}

-(NSString *)mediaFileName {
    return @"movie_bgr_postreg popup_376x812.mp4";
}

@end
