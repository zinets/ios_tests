//
//  AppDelegate.m
//  png2jpg
//
//  Created by Zinets Victor on 8/28/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import "AppDelegate.h"

@interface ListItem : NSObject
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *fileSize;
@property (nonatomic, strong) NSString *fileSizeAfterSaving;
@end

@implementation ListItem
@end

@interface AppDelegate () <NSTableViewDataSource, NSTableViewDelegate> {
    NSMutableArray *dataSource;
}

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *list;
@property (weak) IBOutlet NSTextField *destFilePath;
- (IBAction)onClearTap:(id)sender;
- (IBAction)onRename:(id)sender;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    dataSource = [NSMutableArray array];
    
    _list.dataSource = self;
    [_list reloadData];
    
    [_list registerForDraggedTypes:@[(NSString*)kUTTypeFileURL]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - drag-drop

- (NSDragOperation)tableView:(NSTableView*)tv
                validateDrop:(id < NSDraggingInfo >)info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)op {
    NSPasteboard *pb = info.draggingPasteboard;
    NSArray *acceptedTypes = [NSArray arrayWithObject:(NSString*)kUTTypePNG];
    NSArray *urls = [pb readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
                                      options:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithBool:YES], NSPasteboardURLReadingFileURLsOnlyKey,
                                               acceptedTypes, NSPasteboardURLReadingContentsConformToTypesKey,
                                               nil]];
    if (urls.count > 0) {
        return NSDragOperationCopy;
    } else {
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id < NSDraggingInfo >)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op {
    NSPasteboard *pb = info.draggingPasteboard;
    NSArray *acceptedTypes = [NSArray arrayWithObject:(NSString*)kUTTypePNG];
    
    NSArray *fns = [pb propertyListForType:NSFilenamesPboardType];
    [fns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *arr = [dataSource valueForKey:@"fileName"];
        NSLog(@"%@",arr);
        if (![arr containsObject:obj]) {
            NSFileManager *mgr = [NSFileManager defaultManager];
            ListItem *li = [ListItem new];
            li.fileName = obj;
            NSDictionary *attr = [mgr attributesOfItemAtPath:obj error:nil];
            li.fileSize = attr[NSFileSize];
            
            if ([self.destFilePath stringValue].length == 0) {
                NSString *fn = obj;
                fn = [[fn stringByDeletingLastPathComponent] stringByAppendingString:@"/fakedPNG/"];
                
                [self.destFilePath setStringValue:fn];
            }
            [dataSource addObject:li];
        }
    }];
    [_list reloadData];
    
    return YES;
}


#pragma mark - table

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return dataSource.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ListItem *li = dataSource[row];
    if ([tableColumn.identifier isEqualToString:@"filename"]) {
        return li.fileName;
    } else if ([tableColumn.identifier isEqualToString:@"size"]) {
        return li.fileSize;
    } else if ([tableColumn.identifier isEqualToString:@"afterConvert"]) {
        return li.fileSizeAfterSaving;
    }
    
    return nil;
}

- (IBAction)onClearTap:(id)sender {
    if (_list.selectedRowIndexes.count) {
        NSMutableIndexSet *idxs = [[NSMutableIndexSet alloc] init];
        [_list.selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [idxs addIndex:idx];
        }];
        [dataSource removeObjectsAtIndexes:idxs];
    } else {
        [dataSource removeAllObjects];
    }

    [_list reloadData];
    [_list deselectAll:nil];
}

- (IBAction)onRename:(id)sender {
    if (dataSource.count == 0) return;
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSString *path = [self.destFilePath stringValue];
    NSError *err = nil;
    [mgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
    if (err) {
        NSLog(@"%@", err);
        return;
    }

    NSAlert *alarm = [[NSAlert alloc] init];
    __block BOOL done = YES;
    [dataSource enumerateObjectsUsingBlock:^(ListItem *item, NSUInteger idx, BOOL *stop) {
        if (![self processFile:item destPath:path]) {
            alarm.alertStyle = NSCriticalAlertStyle;
            alarm.informativeText = [NSString stringWithFormat:@"Что-то пошло не так c файлом %@", item.fileName];
            [alarm runModal];
            done = NO;
        }
    }];
    
    if (done) {
        alarm.alertStyle = NSInformationalAlertStyle;
        alarm.messageText = @"Done";
        
        [alarm runModal];
        [_list reloadData];
    }
}

#pragma mark - 

-(BOOL)processFile:(ListItem *)fileItem destPath:(NSString *)destPath {
    BOOL res = NO;
    if ([fileItem.fileName containsString:@".png"]) {
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:fileItem.fileName];
        NSAssert(fileData == nil, @"Все очень плохо, не открылся файл %@", fileItem.fileName);
        
        NSBitmapImageRep *bmp = [[NSBitmapImageRep alloc] initWithData:fileData];
        if (bmp) {
            NSData *data = [bmp representationUsingType:NSJPEGFileType properties:@{}];
            if (data && data.length > 0) {
                NSString *newFn = [destPath stringByAppendingString:[fileItem.fileName lastPathComponent]];
                res = [data writeToFile:newFn atomically:YES];
                fileItem.fileSizeAfterSaving = [NSString stringWithFormat:@"%@", @(data.length)];
            } else {
                NSLog(@"ERROR! empty data!");
            }
        }
    }
    
    return res;
}

@end