//
//  ViewController.m
//  RWTPixelShader
//
//  Created by Zinets Victor on 5/20/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

#import "ViewController.h"
#import "FilterView.h"

@interface ViewController () {
    FilterView *view;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];

    view = [[FilterView alloc] initWithFrame:(CGRect){{20, 40}, {150, 150}}
                                                 context:context];
    [self.view addSubview:view];
    
    NSTimer *tmr = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
}

-(void)onTimer:(id)sender {
    [view setNeedsDisplay];
}

@end
