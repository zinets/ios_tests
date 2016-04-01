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
            sz = (CGSize){104, 104};
            break;
        case CellTypeWideBanner:
            sz = (CGSize){320, 104};
            break;
        case CellTypeSquareCell:
            sz = (CGSize){212, 212};
            break;
        case CellTypeBigCell:
            sz = (CGSize){320, 212};
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
    [self.delegate searchDataSource:self didAddData:@[[NSIndexPath indexPathForItem:3 inSection:0]] removedData:nil];
}

- (void)replaceCells {
    NSMutableOrderedSet *storage = data[0];
    [storage removeObjectAtIndex:1];
    NSArray *removed = @[[NSIndexPath indexPathForItem:1 inSection:0]];
    [storage insertObject:[[self resultObjectByType:(CellTypeWideBanner)] new]
                  atIndex:1];
    NSArray *added = @[[NSIndexPath indexPathForItem:1 inSection:0]];
    
    [self.delegate searchDataSource:self
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
        [self.delegate searchDataSource:self
                             didAddData:nil
                            removedData:arr];
    }
}

@end
