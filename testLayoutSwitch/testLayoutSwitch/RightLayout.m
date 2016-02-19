//
//  RightLayout.m
//  testLayoutSwitch
//
//  Created by Zinets Victor on 2/19/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "RightLayout.h"

@implementation RightLayout

-(CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *res = [NSMutableArray array];
    for (int x = 0; x < 5; x++) {
        [res addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:0]]];
    }
    return res;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = (CGRect){{15, 20}, {290, 480}};
    
    attr.transform = CGAffineTransformMakeScale(1 - 0.1 * indexPath.item, 1 - 0.1 * indexPath.item);
    attr.zIndex = indexPath.item;

    return attr;
}



-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [[self layoutAttributesForItemAtIndexPath:itemIndexPath] copy];
    attr.center = (CGPoint){700, 330};
    return attr;
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [[self layoutAttributesForItemAtIndexPath:itemIndexPath] copy];
    attr.center = (CGPoint){700, 330};
    return attr;
}

@end
