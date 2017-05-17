//
//  ImageDownloader.m
//  TNCache
//
//  Created by Eugene Zhuk on 09.03.15.
//  Copyright (c) 2015 yarra. All rights reserved.
//

#import "TNImageDownloader.h"
#import "TNCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "TNSafeMutableDictionary.h"

// этот класс нужен для того чтоб собрать в кучу в сенеобходимые данные и удобно с ними работать
@interface TNImageDownloaderTaskObject : NSObject
{
    NSMutableSet *_observers;
}
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) TNImageDownloaderPriority taskPriority;

+ (instancetype)new __AVAILABILITY_INTERNAL_UNAVAILABLE;
- (instancetype)init __AVAILABILITY_INTERNAL_UNAVAILABLE;
- (instancetype)initWithUrl:(NSString *)url
               downloadTask:(NSURLSessionDownloadTask *)downloadTask
                   priority:(TNImageDownloaderPriority)priority;

- (void)resumeDownloadTask;
- (void)suspendDownloadTask;
- (void)cancelDownloadTask;

- (NSSet *)observers;
- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end

@implementation TNImageDownloaderTaskObject
- (instancetype)initWithUrl:(NSString *)url
               downloadTask:(NSURLSessionDownloadTask *)downloadTask
                   priority:(TNImageDownloaderPriority)priority {
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
    return [NSString stringWithFormat:@"TNImageDownloaderTaskObject: priority: %lu, observers count: %lu, task: %@", (long)_taskPriority, (unsigned long)_observers.count, _downloadTask];
}

#pragma mark - public
- (void)resumeDownloadTask {
    if (_downloadTask.state != NSURLSessionTaskStateRunning) {
        [_downloadTask resume];
    }
}

- (void)suspendDownloadTask {
    // на паузу таски с дефолтным приоритетом не будем разрешать паузить. их можно кенселить.
    if (_taskPriority == TNImageDownloaderPriorityDefault) {
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

- (NSSet *)observers {
    return _observers;
}

- (void)addObserver:(id)observer {
    if (observer == nil) {
        return;
    }
    if (!_observers) {
        _observers = [NSMutableSet new];
    }
    [_observers addObject:observer];
}

- (void)removeObserver:(id)observer {
    if (observer != nil) {
        [_observers removeObject:observer];
    }
}

@end

@interface TNImageDownloader () <NSURLSessionDownloadDelegate>
{
    NSURLSession *_session;
}

@property (atomic, strong) TNSafeMutableDictionary *tasks;


@end

@implementation TNImageDownloader
#pragma mark - configuration
+ (void)setHTTPAdditionalHeaders:(NSDictionary *)HTTPAdditionalHeaders {
    [TNImageDownloader sharedInstance].HTTPAdditionalHeaders = HTTPAdditionalHeaders;
}

#pragma mark - init
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static TNImageDownloader *_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
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
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:operationQueue];
        _tasks = [TNSafeMutableDictionary new];
    }
    return self;
}

#pragma mark - tasks
- (void)addTask:(TNImageDownloaderTaskObject *)taskObject {
	__weak typeof(self) weakSelf = self;
    [_session.delegateQueue addOperationWithBlock:^{
        NSString *key = taskObject.url;
        weakSelf.tasks[key] = taskObject;
    }];
}

- (void)removeTask:(NSString *)url {
	__weak typeof(self) weakSelf = self;
    [_session.delegateQueue addOperationWithBlock:^{
        TNImageDownloaderTaskObject *downloadObject = weakSelf.tasks[url];
        [downloadObject cancelDownloadTask];
        [weakSelf.tasks removeObjectForKey:url];
        [self resumeTasks];
    }];
}

- (void)resumeTasks {
    // пока/если дефолтные таски еще выполняются, другие не запускаем пока они все не выполнятся
    NSArray *mainTasks = [self allTasksWithPriority:TNImageDownloaderPriorityDefault];
    if (mainTasks.count > 0) {
        [self setResumeForTasks:mainTasks resume:YES];
    }
    NSArray *otherTasks = [self allTasksWithPriority:TNImageDownloaderPriorityLow];
    [self setResumeForTasks:otherTasks resume:mainTasks.count == 0];
    
//#warning для дебага. удалится потом!
//    NSArray *runned = [_tasks.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"downloadTask.state == 0"]];
//    NSArray *paused = [_tasks.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"downloadTask.state != 0"]];
//    NSLog(@"Def: %@ Low: %@ Runned: %@ Paused: %@", @(mainTasks.count), @(otherTasks.count), @(runned.count), @(paused.count));
}

- (void)setResumeForTasks:(NSArray *)tasks resume:(BOOL)resume {
    if (resume) {
        [tasks makeObjectsPerformSelector:@selector(resumeDownloadTask)];
    } else {
        [tasks makeObjectsPerformSelector:@selector(suspendDownloadTask)];
    }
}

- (NSArray *)allTasksWithPriority:(TNImageDownloaderPriority)priority {
    return [self.tasks.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taskPriority == %lu", priority]];
}

#pragma mark - download tasks
- (void)getImagesForUrls:(NSArray *)urls observer:(id<TNImageDownloaderDelegate>)observer {
    [self getImagesForUrls:urls observer:observer priority:TNImageDownloaderPriorityDefault];
}

- (void)getImagesForUrls:(NSArray *)urls observer:(id<TNImageDownloaderDelegate>)observer priority:(TNImageDownloaderPriority)priority {
    BOOL newTasksAdded = NO;
    for (NSString *url in urls) {
        TNImageDownloaderTaskObject *taskObject = [self createDownloadTaskForImageUrl:url observer:observer priority:priority];
        if (taskObject) {
            [self addTask:taskObject];
            newTasksAdded = YES;
        }
    }
    
    [_session.delegateQueue addOperationWithBlock:^{
        if (newTasksAdded) {
            [self resumeTasks];
        }
    }];
}

- (TNImageDownloaderTaskObject *)createDownloadTaskForImageUrl:(NSString *)imageUrl observer:(id<TNImageDownloaderDelegate>)observer priority:(TNImageDownloaderPriority)priority {
    if (!imageUrl || ![imageUrl isKindOfClass:[NSString class]] || imageUrl.length == 0) {
        return nil;
    }
    
    //картинка уже загружена, возвращаем её с кеша обсерверу
    if ([TNCache dataExistForKey:imageUrl]) {
        if (observer && [observer respondsToSelector:@selector(imageDownloader:didDownloadImage:forUrl:)]) {
            UIImage *cachedImage = [TNCache imageForKey:imageUrl];
            [observer imageDownloader:self didDownloadImage:cachedImage forUrl:imageUrl];
        }
        return nil;
    }
    
	TNImageDownloaderTaskObject *taskObject = self.tasks[imageUrl];
    // считаем, что картинка еще не запрашивалась, если обьекта нет
    if (taskObject == nil) {
        NSURL *downloadURL = [NSURL URLWithString:imageUrl];
        NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:downloadURL];
        [self.HTTPAdditionalHeaders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [downloadRequest setValue:obj forHTTPHeaderField:key];
        }];
        NSURLSessionDownloadTask *downloadTask = [_session downloadTaskWithRequest:downloadRequest];
        taskObject = [[TNImageDownloaderTaskObject alloc] initWithUrl:imageUrl downloadTask:downloadTask priority:priority];
        [taskObject addObserver:observer];
        return taskObject;
    } else {
        [taskObject addObserver:observer];
        // если приоритет у задачи поменялся на более высший, то нужно пересмотреть все задачи вызовом resume tasks
        if (priority == TNImageDownloaderPriorityDefault && (taskObject.taskPriority != priority || taskObject.downloadTask.state != NSURLSessionTaskStateRunning)) {
            taskObject.taskPriority = priority;
            return taskObject;
        }
    }
    return nil;
}

#pragma mark - observers
- (void)callObserversForImageUrl:(NSString *)imageUrl witghError:(NSError *)error {
    if (imageUrl && imageUrl.length > 0) {
        TNImageDownloaderTaskObject *downloadObject = self.tasks[imageUrl];
        NSMutableSet *waitingObjects = [downloadObject.observers mutableCopy];
        [self removeTask:imageUrl];
        
        //если обсерверов нет, то и код ниже выполнять нет смымсла
        if (waitingObjects == nil || waitingObjects.count == 0) {
            return;
        }
        if (!error) {
            UIImage *image = [TNCache imageForKey:imageUrl];
            if (image) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    for (id observer in waitingObjects) {
                        if ([observer respondsToSelector:@selector(imageDownloader:didDownloadImage:forUrl:)]) {
                            [observer imageDownloader:self didDownloadImage:image forUrl:imageUrl];
                        }
                    }
                    [waitingObjects removeAllObjects];
                }];
            }
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                for (id observer in waitingObjects) {
                    if (observer && [observer respondsToSelector:@selector(imageDownloader:didFailDownloadImageForUrl:withError:)]) {
                        [observer imageDownloader:self didFailDownloadImageForUrl:imageUrl withError:error];
                    }
                }
                [waitingObjects removeAllObjects];
            }];
        }
    }
}

- (void)removeObserver:(id<TNImageDownloaderDelegate>)observer forImageUrl:(NSString *)imageUrl {
    //удаляем слушателя с очереди для конкретной картинки
    if (imageUrl && imageUrl.length > 0) {
        TNImageDownloaderTaskObject *downloadObject = self.tasks[imageUrl];
        if (downloadObject) {
            [downloadObject removeObserver:observer];
            // если кто-то ждал загрузку фотки по конкретной урл и не дождался, то мы отменяем эту загрузку
            if (downloadObject.observers.count == 0 && downloadObject.taskPriority == TNImageDownloaderPriorityDefault) {
                [self removeTask:imageUrl];
            }
        }
        return;
    }
    //удаляем слушателя со всех очередей
    [self.tasks enumerateKeysAndObjectsUsingBlock:^(id key, TNImageDownloaderTaskObject *object, BOOL *stop) {
        [object removeObserver:observer];
    }];
}

- (void)callObserversForImageUrl:(NSString *)imageUrl withProgress:(float)progress {
    if (imageUrl && imageUrl.length > 0) {
        TNImageDownloaderTaskObject *downloadObject = self.tasks[imageUrl];
        NSSet *waitingObjects = downloadObject.observers;
        //если обсерверов нет, то и код ниже выполнять нет смымсла
        if (waitingObjects == nil || waitingObjects.count == 0) {
            return;
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            for (id observer in waitingObjects) {
                if ([observer respondsToSelector:@selector(imageDownloader:didDownloadDataWithProgress:)]) {
                    [observer imageDownloader:self didDownloadDataWithProgress:progress];
                }
            }
        }];
    }
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *iUrl = downloadTask.response.URL.absoluteString;
    [TNCache setDataFromLocalPath:location forKey:iUrl];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSString *iUrl = task.originalRequest.URL.absoluteString;
    [self callObserversForImageUrl:iUrl witghError:error];
    [self callObserversForImageUrl:iUrl withProgress:(float)task.countOfBytesReceived/task.countOfBytesExpectedToReceive];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSString *iUrl = downloadTask.originalRequest.URL.absoluteString;
    [self callObserversForImageUrl:iUrl withProgress:(float)totalBytesWritten/totalBytesExpectedToWrite];
}

@end
