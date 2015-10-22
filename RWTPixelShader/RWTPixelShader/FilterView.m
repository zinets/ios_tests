//
//  FilterView.m
//  RWTPixelShader
//
//  Created by Zinets Victor on 5/20/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

-(instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context {
    self = [super initWithFrame:frame context:context];
    if (self) {
        // OpenGL ES settings
        glClearColor(1.f, 0.f, 0.f, 1.f);
        
        // Initialize shader
        self.shader = [[RWTBaseShader alloc] initWithVertexShader:@"RWTBase" fragmentShader:@"RWTVoronoy"];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
    
    [self.shader renderInRect:rect atTime:CACurrentMediaTime()];
}

@end
