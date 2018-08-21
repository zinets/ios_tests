//
//  Watcher.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/24/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "Watcher.h"


@implementation Watcher


- (instancetype)initWithObject:(id<ImageDataProviderDelegate>)object type:(ImageType)type {
    if (self = [super init]) {
        _type = type;
        _object = object;
    }
    return self;
}

- (BOOL)isEqual:(Watcher *)toCompare {
    if ([toCompare isKindOfClass:self.class]) {
        return self.object == toCompare.object
        && self.type == toCompare.type;
    }
    return [super isEqual:toCompare];
}

- (NSUInteger)hash {
    return [self.object hash] ^ self.type;
}

@end
