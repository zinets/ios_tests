//
//  UsersListViewController.m
//  testConversations
//
//  Created by Zinets Viktor on 1/17/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "ConversationUsersListViewController.h"

#import "UserListCell.h"
#import "UserListCounterCell.h"

// в дизе в списке юзеров макс. 10 шт, потом - кнопка show all
#define MAX_USERS_COUNT 5
NSInteger itemsCount = 0;

@interface ConversationUsersListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    NSMutableArray <NSString *> *internalItems;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL showAllVisible;

@end

@implementation ConversationUsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    internalItems = [NSMutableArray arrayWithCapacity:100];
    [internalItems addObject:@"0"];
}

#pragma mark setters

- (IBAction)remove:(id)sender {
    NSInteger removed = arc4random_uniform(internalItems.count);
    NSMutableArray *newArray = [NSMutableArray arrayWithArray:internalItems];
    [newArray removeObjectAtIndex:removed];
    
    self.items = newArray;
}

- (IBAction)add:(id)sender {
    NSString *newItem = [NSString stringWithFormat:@"%@", @(itemsCount++)];
    
    NSArray *newArray = [internalItems arrayByAddingObject:newItem];
    self.items = newArray;
}

- (IBAction)combo:(id)sender {
    NSArray *newArray = @[@"1",@"3",@"5",@"6"];
    self.items = newArray;
}

-(void)setItems:(NSArray *)items {
    // я сразу выкину юзеров, которые не могут быть показаны, чтоб не усложнять "логеку"
    NSArray *itemsToAdd = [items subarrayWithRange:(NSRange){0, MIN(MAX_USERS_COUNT, items.count)}];
    
    NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *indexesToInsert = [NSMutableIndexSet indexSet];
    
    [internalItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![itemsToAdd containsObject:obj]) {
            [indexesToRemove addIndex:idx];
        }
    }];
    if (indexesToRemove.count) {
        [internalItems removeObjectsAtIndexes:indexesToRemove];
    }
    
    [itemsToAdd enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![internalItems containsObject:obj]) {
            [indexesToInsert addIndex:internalItems.count];
            [internalItems addObject:obj];
        }
    }];
    
    NSMutableArray *indexPathesToRemove = [NSMutableArray arrayWithCapacity:indexesToRemove.count];
    [indexesToRemove enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPathesToRemove addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }];
    NSMutableArray *indexPathesToInsert = [NSMutableArray arrayWithCapacity:indexesToInsert.count];
    [indexesToInsert enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        [indexPathesToInsert addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }];
    
    [self.collectionView performBatchUpdates:^{
        if (indexPathesToRemove.count) {
            [self.collectionView deleteItemsAtIndexPaths:indexPathesToRemove];
        }
        if (indexPathesToInsert.count) {
            [self.collectionView insertItemsAtIndexPaths:indexPathesToInsert];
        }
        if (self.showAllVisible && items.count <= MAX_USERS_COUNT) { // удалить show all
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:1]];
        } else if (!self.showAllVisible && items.count > MAX_USERS_COUNT) { // добавить show all
            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:1]];
        }
        self.showAllVisible = items.count > MAX_USERS_COUNT;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark collection

// мне так удобно - в первой секции показываем не большее 10 юзеров, в 2й - 1 ячейку с see all

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.showAllVisible ? 2 : 1;
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
            cell.label.text = internalItems[indexPath.item];
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
    
    switch (indexPath.section) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(list:wantsShowUser:)]) {
                [self.delegate list:self wantsShowUser:internalItems[indexPath.item]];
            }
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(listWantsShowAllUsersList:)]) {
                [self.delegate listWantsShowAllUsersList:self];
            }
            break;
        default:
            break;
    }
}

@end
