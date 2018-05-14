//
//  ViewControllerWithCollection.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/11/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewControllerWithCollection.h"
#import "UIColor+MUIColor.h"
#import "HexagonCell.h"
#import "HexagonCollectionLayout.h"

@interface ViewControllerWithCollection () <UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate> {
    NSInteger numberOfItems;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *columnsCount;

@end

@implementation ViewControllerWithCollection

- (void)viewDidLoad {
    [super viewDidLoad];

    HexagonCollectionLayout *layout = self.collectionView.collectionViewLayout;
//    layout.columnsCount = 3;
}

- (IBAction)onTap:(id)sender {
    numberOfItems = 0;
    [self.collectionView reloadData];
}

- (IBAction)addItem:(id)sender {
    numberOfItems++;
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:numberOfItems - 1 inSection:0]]];
}

- (IBAction)removeItem:(id)sender {
    // random delete
//    NSInteger idx = arc4random_uniform(numberOfItems);
//    numberOfItems--;
//    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]]];

    // last element removing
    NSInteger idx = --numberOfItems;
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]]];

}

- (IBAction)incCols:(id)sender {
    HexagonCollectionLayout *layout = self.collectionView.collectionViewLayout;    
    self.columnsCount.text = [NSString stringWithFormat:@"%@", @(++layout.columnsCount)];
}

- (IBAction)decCols:(id)sender {
    HexagonCollectionLayout *layout = self.collectionView.collectionViewLayout;
    self.columnsCount.text = [NSString stringWithFormat:@"%@", @(--layout.columnsCount)];
}

#pragma mark collection -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    HexagonCollectionLayout *layout = (id)collectionView.collectionViewLayout;
    NSInteger count = MIN (numberOfItems, [layout capacityOfLayoutMaxCount:numberOfItems]);
    return numberOfItems;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HexagonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HexagonCell" forIndexPath:indexPath];
    cell.backgroundColor = [[UIColor colorWithHex:arc4random() & 0xffffff] colorWithAlphaComponent:1];
    cell.label.text = [NSString stringWithFormat:@"%d", indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}

@end
