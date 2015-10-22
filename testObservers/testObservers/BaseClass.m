//
//  BaseClass.m
//  testObservers
//
//  Created by Zinetz Victor on 10.12.14.
//  Copyright (c) 2014 Cupid plc. All rights reserved.
//

#import "BaseClass.h"

@implementation BaseClass {
    int v;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        v = 12;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(method1:) name:@"string 1"
                                                   object:nil];
    }
    return self;
}

- (void)doSomething
{
    NSLog(@"%s\nvalue = %d", __PRETTY_FUNCTION__, v);
}

- (void)method1:(id)notification
{
    NSLog(@"%s\n%@", __PRETTY_FUNCTION__, notification);
}

-(void)dealloc
{
    NSLog(@"%s\n", __PRETTY_FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:<#(NSString *)#> object:<#(id)#>forKeyPath:@"string 1"];
}

@end
