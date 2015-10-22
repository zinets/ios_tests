//
//  AppDelegate.h
//  testCachedImages
//
//  Created by Zinetz Victor on 26.02.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *idUrls;

- (IBAction)onTestClick:(id)sender;
@end
