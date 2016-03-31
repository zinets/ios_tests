//
//  Protos.h
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#ifndef Protos_h
#define Protos_h

#import <Foundation/Foundation.h>

static NSString *const reuseIdCell1 = @"c1"; // первый тип ячейки, 104*104
static NSString *const reuseIdCellWideBanner = @"wb"; // 320*104
static NSString *const reuseIdCellSquareCell = @"sc"; // 212*212
static NSString *const reuseIdCellBigCell = @"bc"; // 320*212

typedef NS_ENUM(NSUInteger, CellType) {
    CellType1,
    CellTypeWideBanner,
    CellTypeSquareCell,
    CellTypeBigCell,
};

@protocol ResultObject <NSObject>
- (CellType)cellType;
- (NSString *)cellReuseID;
@end

#endif /* Protos_h */
