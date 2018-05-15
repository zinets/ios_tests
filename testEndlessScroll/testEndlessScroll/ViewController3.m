//
//  ViewController3.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController3.h"
#import "HexagonCollectionView.h"
#import "HexagonCellData.h"

@interface ViewController3 () <HexagonalCollectionDelegate> {
    NSInteger imageIndex;
    NSMutableArray *data;
}
@property (weak, nonatomic) IBOutlet HexagonCollectionView *collectionView;

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [NSMutableArray array];
}

- (IBAction)addObject:(id)sender {
    HexagonCellData *newItem = [HexagonCellData new];
    newItem.avatarUrl = [NSString stringWithFormat:@"i%@.jpg", @(imageIndex % 25)];
    newItem.progress = 0.45;
    imageIndex++;
    
    
    [data addObject:newItem];
    
    self.collectionView.data = data;
}

- (IBAction)replace:(id)sender {
    HexagonCellData *newItem = [HexagonCellData new];
    newItem.avatarUrl = [NSString stringWithFormat:@"i%@.jpg", @(imageIndex % 25)];
    imageIndex++;
    
    NSInteger index2replace = arc4random_uniform(data.count);
    data[index2replace] = newItem;
    
    self.collectionView.data = data;
}

- (IBAction)removeObject:(id)sender {
    [data removeObjectAtIndex:arc4random_uniform(data.count)];
    
    self.collectionView.data = data;
}
- (IBAction)reset:(id)sender {
    imageIndex = 0;
    [data removeAllObjects];
    self.collectionView.data = data;
}

- (void)hexagonalCollectionView:(UIView *)view didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HexagonCellData *data1 = data[indexPath.item];
    data1.progress += 0.05;
}

@end
