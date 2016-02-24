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
        
        self.contentView.backgroundColor = [UIColor colorWithHex:arc4random() & 0xffffff];
        
        UIView *mark = [[UIView alloc] initWithFrame:(CGRect){{}, {10, 10}}];
        mark.backgroundColor = [UIColor redColor];
        mark.center = (CGPoint){frame.size.width / 2, frame.size.height / 2};
        mark.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:mark];
        self.contentView.layer.borderColor = [UIColor redColor].CGColor;
        self.contentView.layer.borderWidth = 1;
    }
    return self;
}

-(void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = [NSString stringWithFormat:@"cell: %p\n%@", self, _title];
    [titleLabel sizeToFit];
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
//    CATransition *t = [CATransition animation];
//    [self.layer addAnimation:t forKey:@"attr"];
    
    [super applyLayoutAttributes:layoutAttributes];

}

@end
