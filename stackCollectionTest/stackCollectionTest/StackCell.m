//
//  StackCell.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackCell.h"

@implementation StackCell {
    UILabel *testLabel;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        self.contentView.backgroundColor = [UIColor colorWithHex:random() & 0x00ffffff];
        
        testLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        [self.contentView addSubview:testLabel];
        
    }
    return self;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    testLabel.text = [NSString stringWithFormat:@"cell %@", @(layoutAttributes.indexPath.item)];
    [testLabel sizeToFit];
}

@end
