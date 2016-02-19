//
//  LeftLayout.m
//  testLayoutSwitch
//
//  Created by Zinets Victor on 2/19/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "LeftLayout.h"

@implementation LeftLayout

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [[self layoutAttributesForItemAtIndexPath:itemIndexPath] copy];
    attr.center = (CGPoint){-100, attr.center.y};
    return attr;
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [[self layoutAttributesForItemAtIndexPath:itemIndexPath] copy];
    attr.center = (CGPoint){-100, attr.center.y};
    return attr;
}

@end
