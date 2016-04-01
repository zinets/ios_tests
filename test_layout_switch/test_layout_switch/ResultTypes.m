//
//  ResultType1.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ResultTypes.h"

@implementation BaseResultType

- (CellType)cellType {
    NSAssert(YES, @"must be overriden!");
    return NSNotFound;
}

+ (Class)cellClass {
    NSAssert(YES, @"must be overriden!");
    return Nil;
}

- (NSString *)cellReuseID {
    return [self.class cellReuseID];
}

+ (NSString *)cellReuseID {
    return [self description];
}

@end


@implementation ResultType1

- (CellType)cellType {
    return CellType1;
}

+ (Class)cellClass {
    return [Cell1 class];
}

@end

@implementation ResultTypeWideBanner

- (CellType)cellType {
    return CellTypeWideBanner;
}

+ (Class)cellClass {
    return [WideBanner class];
}

@end

@implementation ResultTypeSquareCell

- (CellType)cellType {
    return CellTypeSquareCell;
}

+ (Class)cellClass {
    return [SquareCell class];
}

@end

@implementation ResultTypeBigCell

- (CellType)cellType {
    return CellTypeBigCell;
}

+ (Class)cellClass {
    return [BigCell class];
}

@end

