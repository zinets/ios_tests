//
//  UsersListViewController.m
//  testConversations
//
//  Created by Zinets Viktor on 1/17/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "UsersListViewController.h"

#import "UserListCell.h"
#import "UserListCounterCell.h"

@interface UsersListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray *internalItems;
}

@end

@implementation UsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    internalItems = [NSMutableArray arrayWithCapacity:100];
    [internalItems addObject:@1];
}

#pragma mark collection

// мне так удобно - в первой секции показываем не большее 10 юзеров, в 2й - 1 ячейку с see all

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return internalItems.count > 10 ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger res = 0;
    switch (section) {
        case 0:
            res = MIN(10, internalItems.count);
            break;
        case 1:
            res = 1;
            break;
        default:
            break;
    }
    return res;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UserListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserListCell" forIndexPath:indexPath];
            // бла-бла
            return cell;
        }
        case 1: {
            UserListCounterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserListCounterCell" forIndexPath:indexPath];
            return cell;
        }
        default:
            return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (section) {
        case 0: return (UIEdgeInsets){8, 8, 0, 8};
        case 1: return (UIEdgeInsets){8, 0, 0, 8}; // в этой секции 1 ячейка (show all), у нее не должно быть отступа в начале секции для правильного диза
        default: return UIEdgeInsetsZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [internalItems addObject:@(internalItems.count)];
    
    [collectionView reloadData];
}

@end
