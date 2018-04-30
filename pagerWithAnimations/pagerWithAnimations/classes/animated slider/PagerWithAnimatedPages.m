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

- (void)startAnimating {
#warning !! temp timer removed
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.dataSource.count < 2) return;
    
    NSArray <PagerAnimatedCell *> *cells = [self.collectionView visibleCells];
    if (cells.count < 2) return;
    
    CGFloat const d = 80;
    CGFloat w = self.collectionView.bounds.size.width;
    [cells enumerateObjectsUsingBlock:^(PagerAnimatedCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:obj];
        CGFloat offset = scrollView.contentOffset.x - obj.frame.size.width * cellIndexPath.item;
//
//        if (offset > d) { // remove to left
//            [obj removeToLeft];
//        } else if (offset < d - obj.frame.size.width) { // show from right
//            [obj addFromRight];
//        } else if (offset < obj.frame.size.width - d) { // show from left
//            [obj addFromLeft];
//        } else if (offset > obj.frame.size.width - d) { // remove to right
//            [obj removeToRight];
//        }

        if (offset > -295 && obj.contentIsHidden) {
            [obj addFromRight];
        } else if (offset < -295 && !obj.contentIsHidden) {
            [obj removeToRight];
        } else if (offset < -80 && !obj.contentIsHidden) {
            [obj removeToRight];
        }
//        else if (offset > -80) {
//            [obj removeToRight];
//        } else if (offset > 80) {
//            [obj removeToLeft];
//        }
        
    }];
}

@end
