//
//  DownloaderTask.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "DownloaderTask.h"

@implementation DownloaderTask

- (instancetype)initWithUrl:(NSString *)url
               downloadTask:(NSURLSessionDownloadTask *)downloadTask
                   priority:(DownloaderPriority)priority {
    self = [super init];
    if (self) {
        _url = url;
        _downloadTask = downloadTask;
        _taskPriority = -1;
        self.taskPriority = priority;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"TNImageDownloaderTaskObject: priority: %lu, task: %@", (long)_taskPriority, _downloadTask];
}

#pragma mark - public
- (void)resumeDownloadTask {
    if (_downloadTask.state != NSURLSessionTaskStateRunning) {
        [_downloadTask resume];
    }
}

- (void)suspendDownloadTask {
    // на паузу таски с дефолтным приоритетом не будем разрешать паузить. их можно кенселить.
    if (_taskPriority == DownloaderPriorityDefault) {
        return;
    }
    if (_downloadTask.state != NSURLSessionTaskStateSuspended) {
        [_downloadTask suspend];
    }
}

- (void)cancelDownloadTask {
    if (_downloadTask.state != NSURLSessionTaskStateCanceling) {
        [_downloadTask cancel];
    }
}

@end
