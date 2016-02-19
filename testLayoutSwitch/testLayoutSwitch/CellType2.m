//
//  CellType2.m
//  testLayoutSwitch
//
//  Created by Zinets Victor on 2/19/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "CellType2.h"

@implementation CellType2

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 12;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor colorWithHex:arc4random() & 0xffffff];
    }
    return self;
}
@end
