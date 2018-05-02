//
//  PagerWithAnimatedPages.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PagerWithAnimatedPages.h"
#import "PagerAnimatedCell.h"

typedef enum PanDirection {
    PanDirectionNone,
    PanDirectionLeft,
    PanDirectionRight,
} PanDirection;

@implementation PagerWithAnimatedPages {
    BOOL pendingDirectionFromLeft;
}

- (NSString *)cellClassName {
    return @"PagerAnimatedCell";
}

- (CGFloat)sideOffset {
    return 0;
}

- (void)startAnimating {
#warning !! temp timer removed
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.collectionView.scrollEnabled = NO;
        
        UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
        swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.collectionView addGestureRecognizer:swipeLeftRecognizer];
        UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
        swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.collectionView addGestureRecognizer:swipeRightRecognizer];
    }
    return self;
}

- (void)onSwipe:(UISwipeGestureRecognizer *)sender {
    if ((sender.direction & UISwipeGestureRecognizerDirectionLeft) == UISwipeGestureRecognizerDirectionLeft) {
        self.currentPage++;
    } else if ((sender.direction & UISwipeGestureRecognizerDirectionRight) == UISwipeGestureRecognizerDirectionRight) {
        self.currentPage--;
    }
}

-(void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage < 0 || currentPage >= self.dataSource.count) {
        // нехуй шастать за границы
        return;
    }
    NSInteger fromIndex = self.currentPage;
    NSInteger toIndex = currentPage;
    
    if (fromIndex < toIndex) {
        PagerAnimatedCell *fromCell = (id)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0]];
        [fromCell removeToLeft];
        pendingDirectionFromLeft = NO;
        
        [super setCurrentPage:currentPage];
    } else if (toIndex < fromIndex) {
        PagerAnimatedCell *fromCell = (id)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:fromIndex inSection:0]];
        [fromCell removeToRight];
        pendingDirectionFromLeft = YES;
        
        [super setCurrentPage:currentPage];
    }
}

#pragma mark datasource -

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize sz = collectionView.bounds.size;
    return sz;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [super collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    
    PagerAnimatedCell *toCell = (id)cell;
    if (pendingDirectionFromLeft) {
        [toCell addFromLeft];
    } else {
        [toCell addFromRight];
    }
}

- (void)applyData:(PagerItem *)itemData toCell:(UICollectionViewCell *)c {
    PagerAnimatedCell *cell = (id)c;
    cell.titleText = itemData.itemTitle;
    cell.descriptionText = itemData.itemDescription;
//    cell.itemImageUrl = itemData.itemImageUrl;
    
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.dataSource.count < 2) return;
//
//    NSArray <PagerAnimatedCell *> *cells = [self.collectionView visibleCells];
//    if (cells.count < 2) return;
//
//    CGFloat const w = self.collectionView.bounds.size.width;
//    CGFloat const d = w / 2;
//    __block PanDirection dir = PanDirectionNone;
//    if ([scrollView.panGestureRecognizer velocityInView:scrollView].x > 0) {
//        dir = PanDirectionRight;
//    } else if ([scrollView.panGestureRecognizer velocityInView:scrollView].x < 0) {
//        dir = PanDirectionLeft;
//    }
//
//    [cells enumerateObjectsUsingBlock:^(PagerAnimatedCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSIndexPath *cellIndexPath = [self.collectionView indexPathForCell:obj];
//        if (cellIndexPath.item != 1) return ;
//
//        CGFloat x = (scrollView.contentOffset.x - obj.frame.size.width * cellIndexPath.item) / w;
//        NSLog(@"%@", @(x));
//        if (dir == PanDirectionNone) {
//            dir = x  -.5 ? PanDirectionRight : PanDirectionLeft;
//        }
//
//
//        if (x >= -.75 && x < -.5) {
//            if (dir == PanDirectionLeft && obj.contentIsHidden) {
//                [obj addFromRight];
//            } else if (dir == PanDirectionRight && !obj.contentIsHidden) {
//                [obj removeToRight];
//            }
//        } else if (x >= -.5 && x < -.25) {
//            if (dir == PanDirectionRight && !obj.contentIsHidden) {
//                [obj addFromLeft];
//            }
//        } else if (x >= .25 && x < .5) {
//            if (dir == PanDirectionLeft && !obj.contentIsHidden) {
//                [obj removeToLeft];
//            } else if (dir != PanDirectionLeft && obj.contentIsHidden) {
//                [obj addFromLeft];
//            }
//        } else if (x >= 0.5 && x < .75) {
//            if (dir == PanDirectionLeft && !obj.contentIsHidden) {
//                [obj removeToLeft];
//            } else if (dir == PanDirectionRight && obj.contentIsHidden) {
//                [obj addFromLeft];
//            }
//        }
//    }];
//}

@end