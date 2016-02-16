//
//  StackCellAttributes.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/15/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackCellAttributes.h"

@implementation StackCellAttributes

- (id)copyWithZone:(NSZone *)zone {
    StackCellAttributes *attr = [super copyWithZone:zone];
    attr.depth = self.depth;
    return attr;
}

-(BOOL)isEqual:(StackCellAttributes *)object {
    if (self.depth != object.depth) {
        return NO;
    } else {
        return [super isEqual:object];
    }
}

-(void)setDepth:(CGFloat)depth {
    depth = MIN(1, MAX(0, depth));
    if (depth != _depth) {
        _depth = depth;
        
    }
}

@end

