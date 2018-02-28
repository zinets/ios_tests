//
//  ShowVideoSegue.m
//  cameraTest
//
//  Created by Zinets Victor on 2/28/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ShowVideoSegue.h"
#import "CameraController.h"

@implementation ShowVideoSegue

-(void)perform {
    CameraController *ctrl = self.destinationViewController;
    ctrl.isVideoMode = YES;
    
    [super perform];
}

@end
