//
//  LeftLayout.m
//  testLayoutSwitch
//
//  Created by Zinets Victor on 2/19/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "LeftLayout.h"

@implementation LeftLayout {
    CGPoint centerPoint;
}

//- (void)prepareForTransitionToLayout:(UICollectionViewLayout *)newLayout {
//    centerPoint = (CGPoint){};
//}

//- (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout NS_AVAILABLE_IOS(7_0);


-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    CGFloat y = [self collectionViewContentSize].height / 2;
    y = self.collectionView.contentSize.height / 2;
    attr.center = (CGPoint){-100, y};
    return attr;
}

-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:itemIndexPath];
    CGFloat y = self.collectionView.contentSize.height / 2;
    attr.center = (CGPoint){-100, y};
    return attr;
}

@end
