//
//  ViewController.m
//  supplTest
//
//  Created by Zinets Victor on 12/15/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+MUIColor.h"

#import "CollectionDataSource.h"
#import "CollectionViewCell.h"
#import "CollectionHeader.h"
#import "CollectionHeader2.h"
#import "CollectionFooter1.h"
#import "SectionHeader.h"
#import "CollectionBanner.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    SearchLayout *layout;
    CollectionDataSource *dataSource;
}
@property (nonatomic, strong) UICollectionView *collection;

@end

typedef NS_ENUM(NSUInteger, MenuItem) {
    MenuItemReload,
    MenuItemInvalidateLayout,
    MenuItemInvalidateHeader,
};

#define MENU_ITEMS @[@"reload", @"invalidate", @"invalidate header"]

@implementation ViewController


#define CELL_ID @"cell_id"
#define HEADER_ID_BANNER @"collection_header"
#define HEADER_ID_FLIRTCAST @"collection_header2"
#define FOOTER_ID @"collection_footer"
#define SECTION_HEADER_ID @"section_header"
#define BANNER_ID @"banner"


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    
   
    dataSource = [CollectionDataSource new];
    
    layout = [SearchLayout new];
    layout.dataSource = dataSource;
    
    _collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _collection.backgroundColor = [UIColor lightGrayColor];
    
    _collection.dataSource = self;
    _collection.delegate = self;
    
    // ячейка
    [_collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
    
    // заголовок таблицы
    [_collection registerClass:[CollectionHeader class] forSupplementaryViewOfKind:SupplementaryKindCollectionHeaderBanner withReuseIdentifier:HEADER_ID_BANNER];
    [_collection registerNib:[UINib nibWithNibName:@"CollectionHeader2" bundle:nil]
  forSupplementaryViewOfKind:SupplementaryKindCollectionHeaderFlirtcast
         withReuseIdentifier:HEADER_ID_FLIRTCAST];
    // футер таблицы
    [_collection registerNib:[UINib nibWithNibName:@"CollectionFooter1" bundle:nil]
  forSupplementaryViewOfKind:SupplementaryKindCollectionFooter
         withReuseIdentifier:FOOTER_ID];
    
    // заголовок секции
    [_collection registerNib:[UINib nibWithNibName:@"SectionHeader" bundle:nil]
  forSupplementaryViewOfKind:SupplementaryKindSectionHeader
         withReuseIdentifier:SECTION_HEADER_ID];
    
    // баннеры
    [_collection registerNib:[UINib nibWithNibName:@"CollectionBanner" bundle:nil] forSupplementaryViewOfKind:SupplementaryKindBanner withReuseIdentifier:BANNER_ID];
    
    [self.view addSubview:_collection];
    
    // buttons
    self.menu.menuTitles = MENU_ITEMS;
}

#pragma mark - delegation

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [dataSource numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataSource numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.text = [dataSource textForItemAtIndexpath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:SupplementaryKindCollectionHeaderBanner]) {
        CollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_ID_BANNER forIndexPath:indexPath];
        
        return header;
    } else if ([kind isEqualToString:SupplementaryKindCollectionHeaderFlirtcast]) {
        CollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_ID_FLIRTCAST forIndexPath:indexPath];
        
        return header;
    } else if ([kind isEqualToString:SupplementaryKindSectionHeader]) {
        SectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SECTION_HEADER_ID forIndexPath:indexPath];
        
        return header;
    } else if ([kind isEqualToString:SupplementaryKindCollectionFooter]) {
        CollectionFooter1 *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FOOTER_ID forIndexPath:indexPath];
        
        return footer;
    } else if ([kind isEqualToString:SupplementaryKindBanner]) {
        CollectionBanner *banner = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BANNER_ID forIndexPath:indexPath];
        
        return banner;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self invalidateHeaderOnly];
}

#pragma mark - menu

-(void)selectedMenuItemAtIndex:(NSInteger)index{
    switch (index) {
        case MenuItemReload:
            [self reloadAll];
            break;
        case MenuItemInvalidateLayout:
            [self invalidateAll];
            break;
        case MenuItemInvalidateHeader:
            [self invalidateHeaderOnly];
            break;
        default:
            break;
    }
}

#pragma mark - reload crap

- (void)reloadAll {
    [self.collection reloadData];
}

- (void)invalidateAll {
    [self.collection.collectionViewLayout invalidateLayout];
}

- (void)invalidateHeaderOnly {
    CATransition *a = [CATransition animation];
//    [self.collection.layer addAnimation:a forKey:@""];
    
    static int c = 0;
    [self.collection performBatchUpdates:^{
        dataSource.flirtcastVisible = c++ % 3 == 0;;
        dataSource.headerBannerVisible = c % 2 == 0;
        [self.collection.collectionViewLayout invalidateLayout];
        
    } completion:^(BOOL finished) {
        
    }];

    
}

@end
