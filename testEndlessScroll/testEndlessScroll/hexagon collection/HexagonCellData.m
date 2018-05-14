//
//  HexagonCellData.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "HexagonCellData.h"

@implementation HexagonCellData

-(NSUInteger)hash {
    return [self.avatarUrl hash];
}

-(BOOL)isEqual:(HexagonCellData *)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[HexagonCellData class]]) {
        return NO;
    }
    return self.hash == object.hash;
}

@end
