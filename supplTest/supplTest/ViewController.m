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

@interface ViewController () <UICollectionViewDataSource> {
    SearchLayout *layout;
    CollectionDataSource *dataSource;
}
@property (nonatomic, strong) UICollectionView *collection;
@end

typedef NS_ENUM(NSUInteger, MenuItem) {
    MenuItemReload,
};

@implementation ViewController


#define CELL_ID @"cell_id"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    
    NSArray *titlesArray    = [[NSArray alloc] initWithObjects:@"PROFILE", @"FEED", @"ACTIVITY", @"SETTINGS", nil];
    NSArray *imagesArray   = [[NSArray alloc] initWithObjects:@"ic_profile", @"ic_feed", @"ic_activity", @"ic_settings", nil];
    
    TGLGuillotineMenu *menuVC = [[TGLGuillotineMenu alloc] initWithViewControllers:@[] MenuTitles:titlesArray andImagesTitles:imagesArray];
    menuVC.delegate = self;

    
    CGRect frm = self.view.bounds;
    frm.origin.y += 70;
    frm.size.height -= 70;
    
    dataSource = [CollectionDataSource new];
    
    layout = [SearchLayout new];
    layout.dataSource = dataSource;
    
    _collection = [[UICollectionView alloc] initWithFrame:frm collectionViewLayout:layout];
    _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _collection.backgroundColor = [UIColor colorWithHex:0x83d812];
    
    _collection.dataSource = self;
    
    [_collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
    
    [self.view addSubview:_collection];
    
    // buttons
    self.menu.menuTitles = @[@"reload"];
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

-(void)selectedMenuItemAtIndex:(NSInteger)index{
    switch (index) {
        case MenuItemReload:
            [self reloadAll];
            break;
            
        default:
            break;
    }
}

#pragma mark - reload crap

- (void)reloadAll {
    
}

@end
