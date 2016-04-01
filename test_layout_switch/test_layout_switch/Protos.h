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
#import "UIColor+MUIColor.h"

typedef NS_ENUM(NSUInteger, CellType) {
    CellType1,
    CellTypeWideBanner,
    CellTypeSquareCell,
    CellTypeBigCell,
};

@protocol ResultObject <NSObject>
- (CellType)cellType;
- (NSString *)cellReuseID;

+ (NSString *)cellReuseID;
+ (Class)cellClass;
@end

#endif /* Protos_h */
