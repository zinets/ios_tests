//
//  GameModel.h
//  testT1
//
//  Created by Zinets Victor on 9/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ItemType) {
    ItemTypeSquare,
};

@interface GameModel : NSObject {
    NSMutableArray <NSMutableArray *> *matrix;
}
@property (nonatomic, readonly) NSInteger numberOfRows;
@property (nonatomic, readonly) NSInteger numberOfCols;
- (ItemType)itemTypeAtRow:(NSInteger)row col:(NSInteger)col;
@end
