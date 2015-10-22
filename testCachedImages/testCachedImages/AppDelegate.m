//
//  AppDelegate.m
//  testCachedImages
//
//  Created by Zinetz Victor on 26.02.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <NSURLConnectionDelegate> {
    NSMutableData * _data;
}

@end



@implementation AppDelegate 

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    _data = [NSMutableData data];
}

- (IBAction)onTestClick:(id)sender {
    NSString * url = @"http://cdn.imgstat.com/static/photo/thumbnail/_-5DCwETwOFQAQAAAA==.jpg";
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLConnection * connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}



@end


