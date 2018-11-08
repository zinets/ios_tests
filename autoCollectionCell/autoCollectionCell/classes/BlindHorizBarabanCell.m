//
//  BlindHorizBarabanCell.m
//  autoCollectionCell
//
//  Created by Victor Zinets on 11/8/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "BlindHorizBarabanCell.h"

@implementation BlindHorizBarabanCell

// без магии никуда? по дизу высота текста в ячейке 22 пк
#define textHeight 22

-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize sz = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    sz.height = textHeight;
    CGRect frm = layoutAttributes.frame;
    frm.size = sz;
    layoutAttributes.frame = frm;
    
    return layoutAttributes;
}

@end
