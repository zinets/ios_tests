//
//  DataSource.h
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResultTypes.h"

@protocol DataSourceDelegate <NSObject>
@required
- (void)dataSource:(id)sender
        didAddData:(NSArray <NSIndexPath *> *)newIndexes
       removedData:(NSArray <NSIndexPath *> *)removedIndexes;
@end

typedef NS_ENUM(NSUInteger, DataSourceMode) {
    DataSourceMode1,
    DataSourceMode2,
};

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
- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath;
/// метод меняет все "банеры" - сначала удаляет одни, выполняет блок, вставляет другие
- (void)switchToMode:(DataSourceMode)mode withBlock:(void (^)())block;

@property (nonatomic, assign) DataSourceMode mode;
@property (nonatomic, weak) id<DataSourceDelegate>delegate;
@end
