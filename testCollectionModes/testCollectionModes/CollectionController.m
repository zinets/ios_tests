//
//  CollectionController.m
//  testCollectionModes
//
//  Created by Zinets Victor on 2/1/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "CollectionController.h"

#import "Layout.h"
#import "CollectionViewCell.h"

#import "Utils.h"
#import "UIColor+MUIColor.h"

@interface CollectionController ()
@property (nonatomic, assign) BOOL gridMode;

@end

@implementation CollectionController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseIdentifier2 = @"CellExt";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.installsStandardGestureForInteractiveMovement = NO;
    self.collectionView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.7];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[CollectionViewCellExt class]
            forCellWithReuseIdentifier:reuseIdentifier2];
    
    self.gridMode = YES;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId;
    if (indexPath.item % 4 == 1) {
        cellId = reuseIdentifier2;
    } else {
        cellId = reuseIdentifier;
    }
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.title = [NSString stringWithFormat:@"cell: %@:%@", @(indexPath.section), @(indexPath.item)];
    
    NSString *fn = [NSString stringWithFormat:@"0%.2ld.jpg", (long)indexPath.item];
    UIImage *img = [UIImage imageNamed:fn];
    [cell setPhoto:img];
    return cell;
}

#pragma mark - setters

-(void)setGridMode:(BOOL)gridMode {
    if (_gridMode != gridMode) {
        _gridMode = gridMode;

//        [self.collectionView setCollectionViewLayout:[Layout new]
//                                            animated:YES];

//        [self.collectionView performBatchUpdates:^{
//            
//        } completion:^(BOOL finished) {
//        }];
        
        [self.collectionView.collectionViewLayout invalidateLayout];
    }
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.gridMode) {
        return (CGSize){145, 178};
    } else {
        return (CGSize){145*2, 178*2};
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return (UIEdgeInsets){11, 11, 11, 11};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.gridMode = !self.gridMode;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
