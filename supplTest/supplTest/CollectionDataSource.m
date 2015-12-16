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
    return (CGSize){320, 100};
}

- (NSInteger)layout:(UICollectionViewLayout *)layout numberOfBannersInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)layout:(UICollectionViewLayout *)layout indexOfBanner:(NSIndexPath *)bannerIndex {
    return 3;
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
