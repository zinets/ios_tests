//
//  PackageCellLayoutAttributes.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/4/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PackageCellLayoutAttributes.h"

@implementation PackageCellLayoutAttributes

- (BOOL)isEqual:(PackageCellLayoutAttributes *)object {
    return (object.growingPercent == self.growingPercent) && [super isEqual:object];
}

- (id)copyWithZone:(NSZone *)zone {
    PackageCellLayoutAttributes *attr = [super copyWithZone:zone];
    attr.growingPercent = self.growingPercent;
    
    return attr;
}

-(NSString *)description {
    return
    [NSString stringWithFormat:@"item:%ld, growing %%: %f", (long)self.indexPath.item, self.growingPercent];
}

@end
