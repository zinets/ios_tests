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

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    
    
}

- (void)applyData:(PagerItem *)itemData toCell:(UICollectionViewCell *)c {
    PagerAnimatedCell *cell = (id)c;
    cell.titleText = itemData.itemTitle;
    cell.descriptionText = itemData.itemDescription;
//    cell.itemImageUrl = itemData.itemImageUrl;
    
}

@end
