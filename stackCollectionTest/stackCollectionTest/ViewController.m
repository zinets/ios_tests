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

@interface SubItems : NSObject {
    NSMutableArray *intData;
}
- (instancetype)initWithData:(NSArray *)data;
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, readonly) NSMutableArray <NSDictionary *> *items;
@property (nonatomic, assign) NSInteger capacity;

- (void)reset;
@end

@implementation SubItems

-(void)reset {
    self.itemIndex = 0;
}

-(void)setCapacity:(NSInteger)capacity {
    _capacity = capacity;
    [self reset];
}

-(void)setItemIndex:(NSInteger)itemIndex {
    _itemIndex = itemIndex;
    NSInteger maxCount = MIN(intData.count - itemIndex, self.capacity);
    _items = [NSMutableArray arrayWithArray:[intData subarrayWithRange:(NSRange){self.itemIndex, maxCount}]];
}

-(instancetype)initWithData:(NSArray *)data {
    if (self = [super init]) {
        intData = (id)data;
        self.capacity = 4;
    }
    return self;
}

@end

#pragma mark -

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StackLayoutDelegate> {
    SubItems *subItems;
}
@property (nonatomic, strong) StackLayout *listLayout;
@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation ViewController

#define ITEMS_COUNT 6

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *items = [NSMutableArray array];
    
    for (int i = 1; i < ITEMS_COUNT; i++) {
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
        for (int x = 0; x < 4; x++) {
            NSString *fn = [NSString stringWithFormat:@"p%ld.jpg", arc4random() % 16];
            [images addObject:[UIImage imageNamed:fn]];
        }
        NSString *title = [NSString stringWithFormat:@"item #%@", @(i)];
        NSDictionary *d = @{@"title" : title,
                            @"images" : images};
        [items addObject:d];
    }
    subItems = [[SubItems alloc] initWithData:items];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - collection

- (void)registerCells {
    [self.collectionView registerClass:[StackCell class] forCellWithReuseIdentifier:reuseIdStackCell];
}

- (StackLayout *)listLayout {
    if (!_listLayout) {
        _listLayout = [[StackLayout alloc] init];
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
    return subItems.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    StackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdStackCell forIndexPath:indexPath];
    NSDictionary *d = subItems.items[indexPath.item];
    cell.title = d[@"title"];
    cell.images = d[@"images"];
    
    return cell;
}

#pragma mark - stack

-(void)layout:(id)sender didRemoveItemAtIndexpath:(NSIndexPath *)indexPath {
    subItems.itemIndex++;
}

- (void)layout:(id)sender willRestoreItemAtIndexpath:(NSIndexPath *)indexPath {
    subItems.itemIndex--;    
    [self.collectionView reloadData];
}

- (BOOL)hasRemovedItems:(id)sender {
    return subItems.itemIndex > 0;
}

@end
