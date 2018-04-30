//
//  PagerWithAnimatedPages.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PagerWithAnimatedPages.h"
#import "PagerAnimatedCell.h"

@implementation PagerWithAnimatedPages

- (NSString *)cellClassName {
    return @"PagerAnimatedCell";
}

- (CGFloat)sideOffset {
    return 0;
}

#pragma mark datasource -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize sz = collectionView.bounds.size;
    return sz;
}

- (void)applyData:(id)itemData toCell:(UICollectionViewCell *)c {
//    SPagerCell *cell = (id)c;
//    cell.itemTitle = itemData.itemTitle;
//    cell.itemDescription = itemData.itemDescription;
//    cell.itemImageUrl = itemData.itemImageUrl;
}

@end
