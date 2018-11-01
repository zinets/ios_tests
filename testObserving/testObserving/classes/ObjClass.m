//
//  ObjClass.m
//  testObserving
//
//  Created by Victor Zinets on 11/1/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ObjClass.h"

@implementation ObjClass

-(instancetype)init {
    if (self = [super init]) {
        _msgs = [NSMutableArray new];
    }
    return  self;
}

- (void)addMessage:(NSString *)message {
    [_msgs addObject:message];
}

- (void)addRandomElement {
    NSString *str = [NSString stringWithFormat:@"new item %@", [NSDate date]];
    [self addMessage:str];
}

@end
