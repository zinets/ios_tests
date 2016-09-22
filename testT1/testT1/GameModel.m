//
//  GameModel.m
//  testT1
//
//  Created by Zinets Victor on 9/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel {

}

-(instancetype)init {
    if (self = [super init]) {
        matrix = [NSMutableArray arrayWithCapacity:[self numberOfRows]];
        for (int y = 0; y < [self numberOfRows]; y++) {
            NSMutableArray *cols = [NSMutableArray arrayWithCapacity:[self numberOfCols]];
            for (int x = 0; x < [self numberOfCols]; x++) {
                [cols addObject:@0];
            }
            [matrix addObject:cols];
        }
    }
    return self;
}

#pragma mark - public

-(NSInteger)numberOfCols {
    return 4;
}

-(NSInteger)numberOfRows {
    return 4;
}

- (ItemType)itemTypeAtRow:(NSInteger)row col:(NSInteger)col {
    return ItemTypeSquare;
}

@end
