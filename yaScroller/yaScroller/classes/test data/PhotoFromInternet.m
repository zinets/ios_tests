//
//  PhotoFromInternet.m
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PhotoFromInternet.h"

@implementation PhotoFromInternet

-(NSUInteger)hash {
    return self.url.hash;
}

-(BOOL)isEqual:(PhotoFromInternet *)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[PhotoFromInternet class]]) return NO;
    return self.hash == object.hash;
}

@end
