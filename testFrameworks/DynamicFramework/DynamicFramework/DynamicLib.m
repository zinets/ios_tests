//
//  DynamicLib.m
//  DynamicFramework
//
//  Created by Zinets Victor on 6/1/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "DynamicLib.h"

@implementation DynamicLib

+ (NSString *)staticMethod {
    return @"(Dynamic FW) Result is always 42";
}

- (NSString *)instanceMethod:(NSInteger)arg {
    return [NSString stringWithFormat:@"(Dynamic FW) Result is 42 or %@", @(arg)];
}

@end
