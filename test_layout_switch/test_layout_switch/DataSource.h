//
//  DataSource.h
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protos.h"

#import "Cell1.h"
#import "WideBanner.h"
#import "SquareCell.h"
#import "BigCell.h"

@protocol DataSourceDelegate <NSObject>
@required
- (void)searchDataSource:(id)sender didAddData:(NSArray <NSIndexPath *> *)newIndexes removedData:(NSArray <NSIndexPath *> *)removedIndexes;
@end

@interface DataSource : NSObject
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (CGSize)objectSizeByIndexPath:(NSIndexPath *)indexpath;
- (id<ResultObject>)objectByIndexPath:(NSIndexPath *)indexpath;

- (void)fillCellType1;
- (void)fillCellType2;
- (void)insertWideBanner;
- (void)replaceCells;
- (void)deleteBanners;

@property (nonatomic, weak) id<DataSourceDelegate>delegate;
@end
