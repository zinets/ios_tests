//
//  CollectionHeader.m
//  supplTest
//
//  Created by Zinets Victor on 12/16/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "CollectionHeader.h"
#import "UIColor+MUIColor.h"

@implementation CollectionHeader

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:(CGRect){{3, 3}, {0, 0}}];
        lbl.text = @"collection header";
        [lbl sizeToFit];
        [self addSubview:lbl];
        
        self.backgroundColor = [UIColor colorWithHex:random()];
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2;
    }
    return self;
}

@end
