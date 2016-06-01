//
//  DynamicLib.h
//  DynamicFramework
//
//  Created by Zinets Victor on 6/1/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicLib : NSObject
+ (NSString *)staticMethod;
- (NSString *)instanceMethod:(NSInteger)arg;
@end
