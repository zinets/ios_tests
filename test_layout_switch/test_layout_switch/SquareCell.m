//
//  SquareCell.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "SquareCell.h"

@implementation SquareCell

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [UIColor greenColor].CGColor;
        
        lbl.backgroundColor = [UIColor yellowColor];
        lbl.textColor = [UIColor greenColor];
    }
    return self;
}

@end
