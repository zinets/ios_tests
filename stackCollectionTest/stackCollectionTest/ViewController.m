//
//  ViewController.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "StackLayout.h"
#import "StackCell.h"

#import "Utils.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StackLayoutDelegate> {
    NSMutableArray *items;
}
@property (nonatomic, strong) StackLayout *listLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

#define ITEMS_COUNT 5

static NSInteger counter = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    items = [NSMutableArray array];
    
    for (int x = 0; x < ITEMS_COUNT; x++) {
        [items addObject:[NSString stringWithFormat:@"item #%@", @(counter++)]];
    }
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - collection

- (void)registerCells {
    [self.collectionView registerClass:[StackCell class] forCellWithReuseIdentifier:reuseIdStackCell];
}

- (StackLayout *)listLayout {
    if (!_listLayout) {
        _listLayout = [[StackLayout2 alloc] init];
        _listLayout.delegate = self;
    }
    return _listLayout;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.listLayout];
        [self registerCells];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        borderControl(_collectionView);
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdStackCell forIndexPath:indexPath];
    cell.title = items[indexPath.item];
    return cell;
}

#pragma mark - stack

-(void)layout:(id)sender didRemoveItemAtIndexpath:(NSIndexPath *)indexPath {
    [items removeObjectAtIndex:0];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    
    [items addObject:[NSString stringWithFormat:@"item #%@", @(counter++)]];
    NSIndexPath *newItemPath = [NSIndexPath indexPathForItem:(items.count - 1) inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[newItemPath]];
}

@end
