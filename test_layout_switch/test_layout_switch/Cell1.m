//
//  Cell1.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Cell1.h"

@implementation Cell1

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.borderWidth = 2;
        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        self.contentView.backgroundColor = [UIColor blueColor];
    }
    return self;
}

@end
