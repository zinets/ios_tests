//
//  ImageDataProvider.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDataProviderDelegate.h"
#import "DownloaderTypes.h"
#import "TNImageTypes.h"


@interface ImageDataProvider : NSObject

+ (instancetype)sharedInstance;

/// вовзращает картинки из кеша или возвращает её observer-у когда она загрузится
- (void)getImagesForUrls:(NSArray *)urls watcher:(id<ImageDataProviderDelegate>)watcher priority:(DownloaderPriority)priority imageType:(ImageType)imageType;

/// priority = TNImageDownloaderPriorityDefault
- (void)getImagesForUrls:(NSArray *)urls watcher:(id<ImageDataProviderDelegate>)watcher imageType:(ImageType)imageType;

/// удаляет observer из очереди ожидания загрузки картинки
/// загрузка при этом не останавливается
/// imageUrl - опциональный параметр, если его указать, то observer удалится из очереди ожидания загрузки картинки с указанным imageUrl
/// по возможности, лучше передавть imageUrl для более быстрого удаления
- (void)removeWatcher:(id<ImageDataProviderDelegate>)watcher forImageUrl:(NSString *)imageUrl;

/// вернет YES, если в кеше есть картинка для этого урла
- (BOOL)haveImageForUrl:(NSString *)url;

@end
