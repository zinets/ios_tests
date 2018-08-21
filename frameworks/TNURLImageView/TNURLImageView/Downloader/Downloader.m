//
//  Downloader.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "Downloader.h"
#import "DownloaderTask.h"
#import "SafeMutableDictionary.h"


@interface Downloader () <NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSDictionary *HTTPAdditionalHeaders;
@property (nonatomic, strong) NSURLSession *urlSession;
@property (atomic, strong) SafeMutableDictionary *tasks;

@property (nonatomic, weak) id<DownloaderDelegate> delegate;

@end


@implementation Downloader


- (instancetype)initWithDelegate:(id <DownloaderDelegate>)delegate {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        // этим числом может нужно будет поиграться чтоб подобрать оптимальный вариант
        config.HTTPMaximumConnectionsPerHost = 100;
        config.timeoutIntervalForResource = 0;
        config.timeoutIntervalForRequest = 0;
        // код подсмотрен в AFNetworking либе. Используется своя очередь, чтобы сделать вызов методов делегата и комплишинов датаТасков последовательным для избежания возможных крешов
        NSOperationQueue *operationQueue = [NSOperationQueue new];
        operationQueue.maxConcurrentOperationCount = 1;
        _urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:operationQueue];
        _tasks = [SafeMutableDictionary new];
        _delegate = delegate;
    }
    return self;
}


#pragma mark - tasks
- (void)addTask:(DownloaderTask *)task {
    __weak typeof(self) weakSelf = self;
    [_urlSession.delegateQueue addOperationWithBlock:^{
        NSString *key = task.url;
        weakSelf.tasks[key] = task;
    }];
}


- (void)removeTaskWithURL:(NSString *)url {
    __weak typeof(self) weakSelf = self;
    [_urlSession.delegateQueue addOperationWithBlock:^{
        DownloaderTask *task = weakSelf.tasks[url];
        [task cancelDownloadTask];
        [weakSelf.tasks removeObjectForKey:url];
        [self resumeTasks];
    }];
}


- (void)resumeTasks {
    // пока/если дефолтные таски еще выполняются, другие не запускаем пока они все не выполнятся
    NSArray *mainTasks = [self allTasksWithPriority:DownloaderPriorityDefault];
    if (mainTasks.count > 0) {
        [self setResumeForTasks:mainTasks resume:YES];
    }
    NSArray *otherTasks = [self allTasksWithPriority:DownloaderPriorityLow];
    [self setResumeForTasks:otherTasks resume:mainTasks.count == 0];
}


- (void)setResumeForTasks:(NSArray *)tasks resume:(BOOL)resume {
    if (resume) {
        [tasks makeObjectsPerformSelector:@selector(resumeDownloadTask)];
    } else {
        [tasks makeObjectsPerformSelector:@selector(suspendDownloadTask)];
    }
}


- (NSArray *)allTasksWithPriority:(DownloaderPriority)priority {
    return [self.tasks.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taskPriority == %lu", priority]];
}


- (void)createDownloadTaskForImageURL:(NSString *)url priority:(DownloaderPriority)priority {
    
    DownloaderTask *task = self.tasks[url];
    // считаем, что картинка еще не запрашивалась, если обьекта нет
    if (task == nil) {
        NSURL *downloadURL = [NSURL URLWithString:url];
        NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:downloadURL];
        [self.HTTPAdditionalHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [downloadRequest setValue:obj forHTTPHeaderField:key];
        }];
        NSURLSessionDownloadTask *downloadTask = [_urlSession downloadTaskWithRequest:downloadRequest];
        task = [[DownloaderTask alloc] initWithUrl:url downloadTask:downloadTask priority:priority];
    } else {
        // если приоритет у задачи поменялся на более высший, то нужно пересмотреть все задачи вызовом resume tasks
        if (priority == DownloaderPriorityDefault && (task.taskPriority != priority || task.downloadTask.state != NSURLSessionTaskStateRunning)) {
            task.taskPriority = priority;
        }
    }
    
    if (task) {
        [self addTask:task];
    }
    
    [_urlSession.delegateQueue addOperationWithBlock:^{
        [self resumeTasks];
    }];
    
}


- (void)setPriority:(DownloaderPriority)priority forURL:(NSString *)url {
    DownloaderTask *task = self.tasks[url];
    if (task.taskPriority < priority) {
        task.taskPriority = priority;
    }
    [_urlSession.delegateQueue addOperationWithBlock:^{
        [self resumeTasks];
    }];
}


#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *iUrl = downloadTask.response.URL.absoluteString;    
    [self.delegate downloader:self didDownloadDataToURL:location sourceURL:iUrl];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSString *iUrl = task.originalRequest.URL.absoluteString;
    
    [self.delegate downloader:self didFinishDownloadingURL:iUrl withError:error];
    
    if ([self.delegate respondsToSelector:@selector(downloader:didDownloadDataOfURL:withProgress:)]) {
        [self.delegate downloader:self didDownloadDataOfURL:iUrl withProgress:(float)task.countOfBytesReceived/task.countOfBytesExpectedToReceive];
    }
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    NSString *iUrl = downloadTask.originalRequest.URL.absoluteString;
    if ([self.delegate respondsToSelector:@selector(downloader:didDownloadDataOfURL:withProgress:)]) {
        [self.delegate downloader:self didDownloadDataOfURL:iUrl withProgress:(float)downloadTask.countOfBytesReceived/downloadTask.countOfBytesExpectedToReceive];
    }
}


@end
