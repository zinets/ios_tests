//
//  SPager.m
//
//  Created by Victor Zinets on 4/16/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "SPager.h"
#import "SPagerCell.h"
#import "PagerItem.h"

@interface SPager ()  {
}
@end

@implementation SPager

- (NSString *)cellClassName {
    return @"SPagerCell";
}

- (CGFloat)sideOffset {
    return 40; // это ж идея, когда слайд шире окна для красоты листания
}

#pragma mark datasource -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize sz = collectionView.bounds.size;
    sz.width += 2 * self.sideOffset;
    
    return sz;
}

- (void)applyData:(PagerItem *)itemData toCell:(UICollectionViewCell *)c {
    SPagerCell *cell = (id)c;
    cell.itemTitle = itemData.itemTitle;
    cell.itemDescription = itemData.itemDescription;
    cell.itemImageUrl = itemData.itemImageUrl;
}

@end
