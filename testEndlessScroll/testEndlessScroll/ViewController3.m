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

@interface ViewController3 () {
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
    newItem.avatarUrl = [NSString stringWithFormat:@"i%@.jpg", @(imageIndex % 7)];
    imageIndex++;
    
    [data addObject:newItem];
    
    self.collectionView.data = data;
}

- (IBAction)removeObject:(id)sender {
}

@end
