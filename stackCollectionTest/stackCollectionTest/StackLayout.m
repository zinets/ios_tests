//
//  StackLayout.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackLayout.h"
#import "UIView+Geometry.h"

@implementation StackLayout

-(CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat const transformKoef = 0.07;
    CGFloat const height = 415.0;
    CGFloat const vert_spacing = 10;
    switch (indexPath.item) {
        case 0:
            attr.frame = (CGRect){{15, 30}, {290, height}};
            attr.alpha = 1;
            attr.transform3D = CATransform3DIdentity;
//            attr.zIndex = 100 - indexPath.item;
            break;
        case 4:
            attr.frame = (CGRect){{15, 30}, {290, height}};
            attr.alpha = 0.;
            attr.transform3D = CATransform3DMakeScale(1 - transformKoef * indexPath.item, 1 - transformKoef * indexPath.item, 1);
//            attr.zIndex = 100 - indexPath.item;
            break;
        default: {
            attr.frame = (CGRect){{15, 30}, {290, height}};
//            attr.alpha = 1 - indexPath.item * 0.1;
            
            CGFloat k = 1 - transformKoef * indexPath.item;
            CATransform3D transform = CATransform3DIdentity;

            CGFloat dh = (height - k * height) / 2 + (vert_spacing * indexPath.item) / k;
            transform = CATransform3DTranslate(transform, 0, - dh, 0);
            transform = CATransform3DScale(transform, k, k, 1);
            attr.transform3D = transform;
            //            attr.zIndex = 100 - indexPath.item;

        } break;
    }
    


    
    return attr;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *> *res = [NSMutableArray array];
    for (int x = 0; x < [self.collectionView numberOfItemsInSection:0]; x++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:0]];
        [res addObject:attr];
    }
    return res;
}

@end
