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

//-(void)setCenter:(CGPoint)center {
//    [UIView animateWithDuration:0.25 animations:^{
//        [super setCenter:center];
//    }];
//}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    CAAnimationGroup *ag = [CAAnimationGroup animation];
    
    CABasicAnimation *ta = [CABasicAnimation animationWithKeyPath:@"transform"];
    ta.toValue = [NSValue valueWithCGAffineTransform:layoutAttributes.transform];

    CABasicAnimation *tc = [CABasicAnimation animationWithKeyPath:@"center"];
    ta.toValue = [NSValue valueWithCGPoint:layoutAttributes.center];
    
    ag.animations = @[ta, tc];
    [self.layer addAnimation:ag forKey:@"asd"];
    
    if (layoutAttributes.indexPath.item == 1) {
    NSLog(@"\n\n\n%@\n%@",
          [NSValue valueWithCGRect:self.frame],
          [NSValue valueWithCGRect:layoutAttributes.frame]);

    }
}

@end
