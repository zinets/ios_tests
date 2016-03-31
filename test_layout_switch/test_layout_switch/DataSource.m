//
//  DataSource.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "DataSource.h"
#import "ResultTypes.h"

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

- (void)fillCellType1 {
    CellType cells[2][10] = {
        {CellType1, CellType1, CellType1, CellType1, CellType1, CellType1, CellType1, CellTypeBigCell, CellType1, CellType1},
        {CellTypeWideBanner, CellTypeWideBanner, CellTypeWideBanner, CellTypeWideBanner, CellType1, CellType1, CellType1, CellType1, CellType1, CellType1}
    };
    
    for (int section = 0; section < 2; section++) {
        NSMutableOrderedSet *storage = data[section];
        [storage removeAllObjects];
        for (int x = 0; x < 10; x++) {
            [storage addObject:[[self resultObjectByType:cells[section][x]] new]];
        }
    }    
}

@end
