//
//  Downloader.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloaderTypes.h"
#import "DownloaderDelegate.h"

@interface Downloader : NSObject

- (instancetype)initWithDelegate:(id <DownloaderDelegate>)delegate;

- (void)createDownloadTaskForImageURL:(NSString *)url priority:(DownloaderPriority)priority;
- (void)setPriority:(DownloaderPriority)priority forURL:(NSString *)url;
- (void)removeTaskWithURL:(NSString *)url;

@end
