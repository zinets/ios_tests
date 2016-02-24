//
//  StackCell2.m
//  testNewStack
//
//  Created by Zinets Victor on 2/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackCell2.h"

#import "UIColor+MUIColor.h"

@implementation StackCell2 {
    UILabel *titleLabel;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        titleLabel = [[UILabel alloc] initWithFrame:(CGRect){{5, 5}, {}}];
        titleLabel.numberOfLines = 0;
        titleLabel.font = [UIFont systemFontOfSize:8];
        [self.contentView addSubview:titleLabel];
        
        self.title = [NSString stringWithFormat:@"cell: %p", self];
        
        self.contentView.backgroundColor = [UIColor colorWithHex:arc4random()];
    }
    return self;
}

-(void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = _title;
    [titleLabel sizeToFit];
}

@end
