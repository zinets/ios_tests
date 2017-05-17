//
//  ImageDownloader.h
//  TNCache
//
//  Created by Eugene Zhuk on 09.03.15.
//  Copyright (c) 2015 yarra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TNImageDownloaderPriority) {
    TNImageDownloaderPriorityDefault, //выполняется в первую очередь ***и кенселится, если подписчики все удалились***
    TNImageDownloaderPriorityLow, //выполняется только тогда, когда не выполняются ничего с приоритетом выше
};

@class TNImageDownloader;
@protocol TNImageDownloaderDelegate <NSObject>
- (void)imageDownloader:(TNImageDownloader *)imageDownloader didDownloadImage:(UIImage *)image forUrl:(NSString *)imageUrl;
- (void)imageDownloader:(TNImageDownloader *)imageDownloader didFailDownloadImageForUrl:(NSString *)imageUrl withError:(NSError *)error;
@optional
- (void)imageDownloader:(TNImageDownloader *)imageDownloader didDownloadDataWithProgress:(float)progress;
@end

@interface TNImageDownloader : NSObject
@property (nonatomic, strong) NSDictionary *HTTPAdditionalHeaders;

+ (instancetype)sharedInstance;

/// вовзращает картинки из кеша или возвращает её observer-у когда она загрузится
- (void)getImagesForUrls:(NSArray *)urls observer:(id<TNImageDownloaderDelegate>)observer priority:(TNImageDownloaderPriority)priority;
/// priority = TNImageDownloaderPriorityDefault
- (void)getImagesForUrls:(NSArray *)urls observer:(id<TNImageDownloaderDelegate>)observer;
/// удаляет observer из очереди ожидания загрузки картинки
/// загрузка при этом не останавливается
/// imageUrl - опциональный параметр, если его указать, то observer удалится из очереди ожидания загрузки картинки с указанным imageUrl
/// по возможности, лучше передавть imageUrl для более быстрого удаления
- (void)removeObserver:(id<TNImageDownloaderDelegate>)observer forImageUrl:(NSString *)imageUrl;
@end
