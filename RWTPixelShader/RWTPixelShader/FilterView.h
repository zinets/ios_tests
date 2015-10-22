//
//  FilterView.h
//  RWTPixelShader
//
//  Created by Zinets Victor on 5/20/15.
//  Copyright (c) 2015 RayWenderlich. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "RWTBaseShader.h"

@interface FilterView : GLKView
@property (strong, nonatomic, readwrite) RWTBaseShader* shader;
@end
