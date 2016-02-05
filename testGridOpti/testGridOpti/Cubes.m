//
//  Cubes.m
//  testGridOpti
//
//  Created by Zinets Victor on 2/4/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Cubes.h"

@implementation Cubes

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}

-(void)setFrames:(NSArray *)frames {
    _frames = frames;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    [self.frames enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frm = [obj CGRectValue];
        CGRect frame = (CGRect){{frm.origin.x * 50, frm.origin.y * 50}, {50 * frm.size.width, 50 * frm.size.height}};
        
        CGContextSetRGBFillColor(context, rand() % 255 / 255.0, rand() % 255 / 255.0, rand() % 255 / 255.0, 1);
        CGContextFillRect(context, frame);
    }];
}

@end
