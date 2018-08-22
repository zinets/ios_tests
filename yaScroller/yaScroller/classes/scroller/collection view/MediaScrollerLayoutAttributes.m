//
//  MediaScrollerLayoutAttributes.m
//  yaScroller
//
//  Created by Victor Zinets on 8/22/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "MediaScrollerLayoutAttributes.h"

@implementation MediaScrollerLayoutAttributes

-(id)copyWithZone:(NSZone *)zone {
    MediaScrollerLayoutAttributes *attrs = [super copyWithZone:zone];
    attrs.contentMode = self.contentMode;
    return attrs;
}

-(BOOL)isEqual:(id)object {
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    if (object == self) {
        return YES;
    }
    
    if (((MediaScrollerLayoutAttributes *)object).contentMode != self.contentMode) {
        return NO;
    }
    
    BOOL res = [super isEqual:object];
    
    return res;
}

@end
