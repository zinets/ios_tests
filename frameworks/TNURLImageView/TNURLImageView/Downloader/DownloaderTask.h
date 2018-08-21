//
//  DownloaderTask.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloaderTypes.h"


@interface DownloaderTask : NSObject

@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) DownloaderPriority taskPriority;

+ (instancetype)new __AVAILABILITY_INTERNAL_UNAVAILABLE;
- (instancetype)init __AVAILABILITY_INTERNAL_UNAVAILABLE;
- (instancetype)initWithUrl:(NSString *)url
               downloadTask:(NSURLSessionDownloadTask *)downloadTask
                   priority:(DownloaderPriority)priority;

- (void)resumeDownloadTask;
- (void)suspendDownloadTask;
- (void)cancelDownloadTask;

@end
