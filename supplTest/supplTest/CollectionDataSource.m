//
//  CollectionDataSource.m
//  supplTest
//
//  Created by Zinets Victor on 12/15/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "CollectionDataSource.h"


@implementation CollectionDataSource

-(CGSize)minimumCellSizeForLayout:(UICollectionViewLayout *)layout {
    return (CGSize){104, 104};
}

-(CGFloat)minimumCellSpacingForLayout:(UICollectionViewLayout *)layout {
    return 4;
}

-(CGFloat)sideCellInsetForLayout:(UICollectionViewLayout *)layout {
    return 0;
}

-(CGSize)layout:(UICollectionViewLayout *)layout cellSizeForIndexpath:(NSIndexPath *)indexPath {
    if (indexPath.item == 4) {
        return (CGSize){212, 212};
    }
    return (CGSize){104, 104};
}

-(CGSize)layout:(UICollectionViewLayout *)layout supplementarySizeForKind:(NSString *)kind forIndexpath:(NSIndexPath *)indexPath {
    CGSize res = CGSizeZero;
    if ([kind isEqualToString:SupplementaryKindBanner]) {
        if (indexPath.row == 0) {
            res = (CGSize){320, 50};
        } else {
            res = (CGSize){212, 212};
        }
    } else if ([kind isEqualToString:SupplementaryKindCollectionHeaderBanner] && self.headerBannerVisible) {
        res = (CGSize){320, 70};
    } else if ([kind isEqualToString:SupplementaryKindCollectionHeaderFlirtcast] && self.flirtcastVisible) {
        res = (CGSize){320, 70};
    }
    return res;
}

- (NSInteger)layout:(UICollectionViewLayout *)layout numberOfBannersInSection:(NSInteger)section {
    NSInteger res = 0;
    switch (section) {
        case 0:
            res = 2;
            break;
        case 1:
            res = 1;
            break;
        default:
            break;
    }
    return res;
}

- (NSInteger)layout:(UICollectionViewLayout *)layout indexOfBanner:(NSIndexPath *)bannerIndex {
    return 2;
}

- (BOOL)layout:(UICollectionViewLayout *)layout useFooterType:(FooterType)footerType {
    return YES;
}

#pragma mark - data

- (NSInteger)numberOfSections {
    return 2;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    NSInteger res = 11;
    switch (section) {
        case 0:
            res = 15;
            break;
            
        default:
            break;
    }
    return res;
}

- (NSString *)textForItemAtIndexpath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"s: %@\ni:%@", @(indexPath.section), @(indexPath.item)];
}

@end
