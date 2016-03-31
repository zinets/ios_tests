//
//  WideBanner.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "WideBanner.h"

@implementation WideBanner

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.borderWidth = 2;
        self.contentView.layer.borderColor = [UIColor yellowColor].CGColor;
        
        lbl.backgroundColor = [UIColor blackColor];
        lbl.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
