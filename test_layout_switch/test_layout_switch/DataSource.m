//
//  DataSource.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "DataSource.h"

@interface DataSource () {
    NSArray <NSMutableOrderedSet *> *data;
}
@end



@implementation DataSource

-(instancetype)init {
    if (self = [super init]) {
        NSMutableOrderedSet *matchedSection = [NSMutableOrderedSet orderedSet];
        NSMutableOrderedSet *relatedSection = [NSMutableOrderedSet orderedSet];
        // keep in touch with Sections enum!
        data = @[matchedSection, relatedSection];
    }
    return self;
}

- (NSInteger)numberOfSections {
    return data.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [data[section] count];
}

- (CGSize)objectSizeByIndexPath:(NSIndexPath *)indexpath {
    id obj = data[indexpath.section][indexpath.item];
    CGSize sz = CGSizeZero;
    
    switch ([obj cellType]) {
        case CellType1:
            sz = (CGSize){106, 106};
            break;
        case CellTypeWideBanner:
            sz = (CGSize){320, 106};
            break;
        case CellTypeSquareCell:
            sz = (CGSize){212, 212};
            break;
        case CellTypeBigCell:
            sz = (CGSize){320, (self.mode == DataSourceMode1 ? 212 : 50)};
            break;
        default:
            break;
    }
    return sz;
}

- (id<ResultObject>)objectByIndexPath:(NSIndexPath *)indexpath {
    id obj = data[indexpath.section][indexpath.item];
    return obj;
}

#pragma mark -

- (Class)resultObjectByType:(CellType)type {
    switch (type) {
        case CellType1:
            return [ResultType1 class];
        case CellTypeBigCell:
            return [ResultTypeBigCell class];
        case CellTypeSquareCell:
            return [ResultTypeSquareCell class];
        case CellTypeWideBanner:
            return [ResultTypeWideBanner class];
        default:
            return Nil;
    }
}

static const CellType startCells[2][6] = {
    {
        CellType1, CellTypeSquareCell, CellType1,
        CellTypeWideBanner,
        CellType1, CellType1
    }, {
        CellType1, CellType1, CellType1,
        CellTypeWideBanner,
        CellType1, CellType1
    }
};

static const CellType cells2[2][5] = {
    {
        CellType1, CellType1, CellType1,
        CellTypeBigCell,
        CellType1
    }, {
        CellType1, CellType1,
        CellTypeWideBanner,
        CellType1, CellType1
    }
};

- (void)fillCellType1 {
    for (int section = 0; section < 2; section++) {
        NSMutableOrderedSet *storage = data[section];
        [storage removeAllObjects];
        for (int x = 0; x < 6; x++) {
            [storage addObject:[[self resultObjectByType:startCells[section][x]] new]];
        }
    }
}

- (void)fillCellType2 {
    for (int section = 0; section < 2; section++) {
        NSMutableOrderedSet *storage = data[section];
        [storage removeAllObjects];
        for (int x = 0; x < 5; x++) {
            [storage addObject:[[self resultObjectByType:cells2[section][x]] new]];
        }
    }
}

- (void)insertWideBanner {
    NSMutableOrderedSet *storage = data[0];
    [storage insertObject:[[self resultObjectByType:(CellTypeWideBanner)] new]
                  atIndex:3];
    [self.delegate dataSource:self didAddData:@[[NSIndexPath indexPathForItem:3 inSection:0]] removedData:nil];
}

- (void)replaceCells {
    NSMutableOrderedSet *storage = data[0];
    [storage removeObjectAtIndex:1];
    NSArray *removed = @[[NSIndexPath indexPathForItem:1 inSection:0]];
    [storage insertObject:[[self resultObjectByType:(CellTypeWideBanner)] new]
                  atIndex:1];
    NSArray *added = @[[NSIndexPath indexPathForItem:1 inSection:0]];
    
    [self.delegate dataSource:self
                         didAddData:added
                        removedData:removed];
}

- (void)deleteBanners {
    NSMutableOrderedSet *storage = data[0];
    __block NSMutableArray *arr = [NSMutableArray array];
    __block NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    [storage enumerateObjectsUsingBlock:^(id<ResultObject> obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj cellType] == CellTypeWideBanner) {
            [arr addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
            [set addIndex:idx];
        }
    }];
    if (arr.count > 0) {
        [storage removeObjectsAtIndexes:set];
        [self.delegate dataSource:self
                             didAddData:nil
                            removedData:arr];
    }
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableOrderedSet *storage = data[indexPath.section];
    [storage removeObjectAtIndex:indexPath.item];
    
    [self.delegate dataSource:self didAddData:nil removedData:@[indexPath]];
}

// для простоты только в секции 0
- (void)switchToMode:(DataSourceMode)mode withBlock:(void (^)())block {
    
    self.mode = mode;
    
    NSMutableOrderedSet *storage = data[0];
    __block NSMutableArray *arr = [NSMutableArray array];
    __block NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    
    switch (self.mode) {
        case DataSourceMode1: {
            [storage enumerateObjectsUsingBlock:^(id <ResultObject> obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj cellType] == CellType1) {
                    [arr addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
                    [set addIndex:idx];
                }
            }];
            if (set.count) {
                [storage removeObjectsAtIndexes:set];
                [self.delegate dataSource:self
                               didAddData:nil
                              removedData:arr];
            }
            if (block) {
                block();
            }
            if (set.count) {
                [arr removeAllObjects];
                [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                    [arr addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
                    [storage insertObject:[[self resultObjectByType:(CellTypeWideBanner)] new]
                                  atIndex:idx];
                }];
                [self.delegate dataSource:self
                               didAddData:arr
                              removedData:nil];
            }
        } break;
        case DataSourceMode2: {
            [storage enumerateObjectsUsingBlock:^(id <ResultObject> obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj cellType] == CellTypeWideBanner ||
                    [obj cellType] == CellTypeSquareCell) {
                    [arr addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
                    [set addIndex:idx];
                }
            }];
            // сначала ищу все ячейки wide и square, если есть - удаляю
            if (arr.count > 0) {
                [storage removeObjectsAtIndexes:set];
                [self.delegate dataSource:self
                               didAddData:nil
                              removedData:arr];
            }
            // затем блок; в нем коллекция переключит раскладку, теоретически остаются только элементы, "общие" для разных режимов
            if (block) {
                block();
            }
            // затем вставляются новые элементы, которые присущи новой раскладке (ну допустим буду добавлять их только если были удаленные - просто для упрощения и проверки переключения именно раскладки
            if (arr.count) {
                [arr removeAllObjects];
                [arr addObject:[NSIndexPath indexPathForItem:0 inSection:0]];
                [storage insertObject:[[self resultObjectByType:(CellTypeBigCell)] new]
                              atIndex:0];
                
                [arr addObject:[NSIndexPath indexPathForItem:3 inSection:0]];
                [storage insertObject:[[self resultObjectByType:(CellTypeBigCell)] new]
                              atIndex:3];
                
                NSInteger lastIndex = storage.count;
                [arr addObject:[NSIndexPath indexPathForItem:lastIndex inSection:0]];
                [storage insertObject:[[self resultObjectByType:(CellTypeBigCell)] new]
                              atIndex:lastIndex];
                
                [self.delegate dataSource:self didAddData:arr removedData:nil];
            }
        } break;
            
        default:
            break;
    }
}

@end
