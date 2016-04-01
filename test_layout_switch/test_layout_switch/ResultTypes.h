//
//  ResultType1.h
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Protos.h"

#import "Cell1.h"
#import "WideBanner.h"
#import "SquareCell.h"
#import "BigCell.h"

@interface BaseResultType : NSObject <ResultObject>
@end

@interface ResultType1 : BaseResultType // первый тип ячейки, 104*104
@end
@interface ResultTypeWideBanner : BaseResultType // 320*104
@end
@interface ResultTypeSquareCell : BaseResultType // 212*212
@end
@interface ResultTypeBigCell : BaseResultType // 320*212
@end