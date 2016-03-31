//
//  Layout.m
//  testCollL
//
//  Created by Zinets Victor on 3/17/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Layout.h"

@implementation Layout {
    NSMutableDictionary *attributes;
    CGSize contentSize;
}

- (CGSize)collectionViewContentSize {
    return contentSize;
}

-(void)prepareLayout {
    NSInteger nums = [self.collectionView numberOfItemsInSection:0];
    if (!attributes) {
        attributes = [NSMutableDictionary dictionaryWithCapacity:nums];
    }
    [attributes removeAllObjects];
    
    CGRect contentRect = {};
    CGFloat y = 0;

    for (int x = 0; x < nums; x++) {
        CGRect frm = (CGRect){{0, y}, {300, 78}};
        NSIndexPath *idx = [NSIndexPath indexPathForItem:x inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:idx];
        
        if (x == 2) {
            frm.size.height = 130;
        }
        y += frm.size.height;
        attr.frame = frm;
        attributes[idx] = attr;
        
        contentRect = CGRectUnion(contentRect, frm);
    }
    contentSize = contentRect.size;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return attributes[indexPath];
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return attributes.allValues;
}

@end
