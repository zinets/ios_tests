//
//  CellType1.m
//  testLayoutSwitch
//
//  Created by Zinets Victor on 2/19/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "CellType1.h"
#import "UIColor+MUIColor.h"

@implementation CellType1 {
    UILabel *label;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 6;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor colorWithHex:arc4random() & 0xffffff];
        
        label = [UILabel new];
        label.frame = (CGRect){{10, 10}, {}};
        [self.contentView addSubview:label];
    }
    return self;
}

-(void)setTitle:(NSString *)title {
    _title = title;
    label.text = _title;
    [label sizeToFit];
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    [self invalidateIntrinsicContentSize];
}

@end
