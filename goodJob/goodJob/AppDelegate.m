//
//  AppDelegate.m
//  goodJob
//
//  Created by Zinets Victor on 4/29/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    NSArray <NSString *> *goodList;
}

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *generatedText;
@property (weak) IBOutlet NSTextField *copyright;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSDictionary *tempDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"goodList" ofType:@"plist"]];
    goodList = tempDict[@"list"];

    [self.generatedText setStringValue:goodList[arc4random() % goodList.count]];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [self.copyright setStringValue:[NSString stringWithFormat:@"(c) 2016, Zinets Victor, v.%@", version]];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)on1:(NSButton *)sender {
    [self.generatedText setStringValue:goodList[arc4random() % goodList.count]];
}

- (IBAction)onCopyTap:(id)sender {
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] setString:[self.generatedText stringValue]
                                        forType:NSPasteboardTypeString];

}

@end
