//
//  ElasticTableView.m
//  testElacticScroll
//
//  Created by Zinetz Victor on 01.10.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "ElasticTableView.h"

@implementation ElasticTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch began");
    [super touchesBegan:touches withEvent:event];
}

@end
