//
//  Layout.m
//  testCollectionModes
//
//  Created by Zinets Victor on 1/29/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Layout.h"

@interface Layout ()
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;
@end

@implementation Layout

//-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attr = [[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath] copy];
//    attr.transform3D = CATransform3DMakeTranslation(itemIndexPath.item % 2 == 0 ? -attr.center.x : attr.center.x, 0, 0);
//    attr.alpha = 0;
//    return attr;
//}

//-(UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
//    UICollectionViewLayoutAttributes *attr = [[super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath] copy];
//    attr.transform3D = CATransform3DMakeTranslation(itemIndexPath.item % 2 == 0 ? -attr.center.x : attr.center.x, 0, 0);
//    attr.alpha = 0;
//    return attr;
//}


//- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
//    [super prepareForCollectionViewUpdates:updateItems];
//    
//    NSMutableArray *indexPaths = [NSMutableArray array];
//    for (UICollectionViewUpdateItem *updateItem in updateItems) {
//        switch (updateItem.updateAction) {
//            case UICollectionUpdateActionInsert:
//                [indexPaths addObject:updateItem.indexPathAfterUpdate];
//                break;
//            case UICollectionUpdateActionDelete:
//                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
//                break;
//            case UICollectionUpdateActionMove:
//                [indexPaths addObject:updateItem.indexPathBeforeUpdate];
//                [indexPaths addObject:updateItem.indexPathAfterUpdate];
//                break;
//            default:
//                NSLog(@"unhandled case: %@", updateItem);
//                break;
//        }
//    }
//    self.indexPathsToAnimate = indexPaths;
//}
//
//- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
//    
//    if ([_indexPathsToAnimate containsObject:itemIndexPath]) {
//        attr.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), M_PI);
//        attr.center = CGPointMake(CGRectGetMidX(self.collectionView.bounds), CGRectGetMaxY(self.collectionView.bounds));
//        [_indexPathsToAnimate removeObject:itemIndexPath];
//    }
//    
//    return attr;
//}

@end
