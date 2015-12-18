//
//  ViewController.m
//  NYQ
//
//  Created by Zinets Victor on 12/18/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

#import "PageLayout.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, PageLayoutProto> {
    UICollectionView *_collection;
}

@end

#define CELL_ID @"cell"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PageLayout *layout = [PageLayout new];
    layout.delegate = self;
    
    _collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collection];
    
    [_collection registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CELL_ID];
    _collection.dataSource = self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    
}

#pragma mark - collection

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.image = nil;
    
    return cell;
}

#pragma mark - moving delegation

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath
           toIndexPath:(NSIndexPath *)toIndexPath {
    return YES;
}

/// ячейки поменялись местами - нужно обновить датасорс
- (void)collectionView:(UICollectionView *)collectionView
     didMoveItemAtPath:(NSIndexPath *)fromIndex
                toPath:(NSIndexPath *)toIndex {
    
}

@end
