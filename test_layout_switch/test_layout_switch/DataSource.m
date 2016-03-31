//
//  DataSource.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "DataSource.h"
#import "ResultType1.h"

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
    return (CGSize){104, 104};
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
    }
}

@end
