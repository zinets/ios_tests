//
//  BigCell.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "BigCell.h"

@implementation BigCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        
        lbl.backgroundColor = [UIColor whiteColor];
        lbl.textColor = [UIColor blackColor];
    }
    return self;
}

@end
