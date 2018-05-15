//
//  HexagonCellData.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "HexagonCellData.h"

NSString * const HexCellDataChanged = @"HexCellDataChanged";

@implementation HexagonCellData

-(NSUInteger)hash {
    return [self.avatarUrl hash] ^ [@(self.progress) hash];
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

#pragma mark setters -

- (void)setProgress:(CGFloat)progress {
    progress = MAX(0, MIN(1, progress));
    if (_progress != progress) {
        _progress = progress;

        [[NSNotificationCenter defaultCenter] postNotificationName:HexCellDataChanged object:self];
    }
}

@end
