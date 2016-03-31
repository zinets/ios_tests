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

- (id)createResultType1 {
    id obj = [ResultType1 new];
    
    return obj;
}

- (void)fillCellType1 {
    NSMutableOrderedSet *storage = data[0];
    [storage removeAllObjects];
    for (int x = 0; x < 12; x++) {
        [storage addObject:[ResultType1 new]];
        if (x == 2) {
            [storage addObject:[ResultTypeSquareCell new]];
        }
        if (x == 4) {
            [storage addObject:[ResultTypeBigCell new]];
        }
    }
    
    storage = data[1];
    [storage removeAllObjects];
    for (int x = 0; x < 2; x++) {
        [storage addObject:[ResultTypeWideBanner new]];
    }

}

@end
