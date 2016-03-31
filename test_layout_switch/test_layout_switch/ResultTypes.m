//
//  ResultType1.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ResultTypes.h"

@implementation ResultType1

- (CellType)cellType {
    return CellType1;
}

- (NSString *)cellReuseID {
    return reuseIdCell1;
}

@end

@implementation ResultTypeWideBanner

- (CellType)cellType {
    return CellTypeWideBanner;
}

- (NSString *)cellReuseID {
    return reuseIdCellWideBanner;
}

@end

@implementation ResultTypeSquareCell

- (CellType)cellType {
    return CellTypeSquareCell;
}

- (NSString *)cellReuseID {
    return reuseIdCellSquareCell;
}

@end

@implementation ResultTypeBigCell

- (CellType)cellType {
    return CellTypeBigCell;
}

- (NSString *)cellReuseID {
    return reuseIdCellBigCell;
}

@end

