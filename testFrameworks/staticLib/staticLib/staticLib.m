//
//  StaticLib.m
//  StaticLib
//
//  Created by Zinets Victor on 6/1/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StaticLib.h"

@implementation StaticLib

+ (NSString *)staticMethod {
    return @"Result is always 42";
}

- (NSString *)instanceMethod:(NSInteger)arg {
    return [NSString stringWithFormat:@"Result is 42 or %@", @(arg)];
}

@end
