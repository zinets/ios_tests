//
//  ImageDataProvider.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "ImageDataProvider.h"
#import "DownloaderDelegate.h"
#import "SafeMutableDictionary.h"
#import "Downloader.h"
#import "ImageDataProviderTask.h"
// cache
#import "Cache.h"
// processors
#import "GrayscaleImageProcessor.h"
#import "PixelateImageProcessor.h"
#import "BlurImageProcessor.h"


@interface ImageDataProvider () <DownloaderDelegate>

@property (nonatomic, strong) Downloader *downloader;
@property (nonatomic, strong) NSMutableDictionary <NSString *, ImageDataProviderTask *> *dataProviderTasks;

@end


@implementation ImageDataProvider


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ImageDataProvider *_sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (instancetype)init {
    self = [super init];
    self.downloader = [[Downloader alloc] initWithDelegate:self];
    self.dataProviderTasks = [NSMutableDictionary new];
    return self;
}


- (void)removeWatcher:(id<ImageDataProviderDelegate>)watcher forImageUrl:(NSString *)imageUrl {
    //удаляем слушателя с очереди для конкретной картинки
    if (imageUrl && imageUrl.length > 0) {
        ImageDataProviderTask *task = self.dataProviderTasks[imageUrl];
        if (task) {
            [task removeWatcher:watcher];
            // если кто-то ждал загрузку фотки по конкретной урл и не дождался, то мы отменяем эту загрузку
            if (task.watchers.count == 0) {
                [_downloader removeTaskWithURL:imageUrl];
            }
        }
    }
}


- (void)getImagesForUrls:(NSArray *)urls watcher:(id<ImageDataProviderDelegate>)watcher imageType:(ImageType)imageType {
    [self getImagesForUrls:urls watcher:watcher priority:DownloaderPriorityDefault imageType:imageType];
}

- (BOOL)haveImageForUrl:(NSString *)url  {
    BOOL retVal = [Cache dataExistForKey:url];
    return retVal;
}


- (UIImage *)postprocessImageForURLString:(NSString *)urlString withType:(ImageType)imageType {
    UIImage *sourceImage = [[UIImage alloc] initWithData:[Cache dataForKey:urlString]];
    
    // постобработка
    UIImage *destinationImage = [self postprocessImage:sourceImage toType:imageType];
    
    // прогреем кеш
    [Cache setData:UIImagePNGRepresentation(destinationImage) forKey:[self keyForURLString:urlString ofType:imageType]];
    
    return destinationImage;
}


- (void)getImagesForUrls:(NSArray *)urls watcher:(id<ImageDataProviderDelegate>)watcher priority:(DownloaderPriority)priority imageType:(ImageType)imageType {
    
    for (NSString *url in urls) {
        
        if (!url || ![url isKindOfClass:[NSString class]] || url.length == 0) {
            return;
        }
        
        NSString *normalKey = url;
        NSString *requestedKey = [self keyForURLString:url ofType:imageType];
        
        // проверить кеш на наличие постобработанной фотки если она нужна
        if (requestedKey != nil && [Cache dataExistForKey:requestedKey]) {
            
            [watcher dataProvider:self didLoadImage:[Cache imageForKey:requestedKey] fromURL:url];
            
        // проверить на наличие фотки в кеше (оригинал)
        } else if (normalKey != nil && [Cache dataExistForKey:normalKey]) {
            
            // если есть оригинал и нужна постобработка
            if (requestedKey != nil) {
                
                UIImage *destinationImage = [self postprocessImageForURLString:normalKey withType:imageType];
                
                // уведомим жаждущего
                [watcher dataProvider:self didLoadImage:destinationImage fromURL:url];
                
            // если есть и НЕ нужна постобработка
            } else {
                
                // сразу отдаём результат
                UIImage *image = [[UIImage alloc] initWithData:[Cache dataForKey:normalKey]];
                [watcher dataProvider:self didLoadImage:image fromURL:url];
                
            }
            
        // если нет - грузим
        } else {
            
            ImageDataProviderTask *t = self.dataProviderTasks[url];
            
            // если такую фотку уже кто-то запросил
            if (t != nil) {
                
                // дописать еще желающих на получение фото
                [t addWatcher:watcher forType:imageType];
                
                // сменить приоритет
                [_downloader setPriority:priority forURL:url];
                
            // никто не запрашивал
            } else {
                
                t = [[ImageDataProviderTask alloc] initWithURL:url];
                [t addWatcher:watcher forType:imageType];
                
                self.dataProviderTasks[url] = t;
                
                [_downloader createDownloadTaskForImageURL:url priority:priority];
            }
        }
    }
}



- (NSString *)keyForURLString:(NSString *)urlString ofType:(ImageType)type {
    return (type == ImageTypeNormal) ? nil : [urlString stringByAppendingFormat:@"type%lu", (unsigned long)type];
}


- (UIImage *)postprocessImage:(UIImage *)sourceImage toType:(ImageType)type {
    switch (type) {
        case ImageTypeNormal:
            return sourceImage;
        case ImageTypeGrayscale:
            return [GrayscaleImageProcessor processImage:sourceImage];
        case ImageTypePixelated:
            return [PixelateImageProcessor processImage:sourceImage];
        case ImageTypeBlurred:
            return [BlurImageProcessor processImage:sourceImage];
    }
}


- (void)callWatchersForURLString:(NSString *)url withError:(NSError *)error {
    ImageDataProviderTask *t = self.dataProviderTasks[url];
    
    [t.watchers enumerateObjectsUsingBlock:^(Watcher * _Nonnull obj, BOOL * _Nonnull stop) {
        if (error) {
            [obj.object dataProvider:self didFailLoadingImageFromURL:url];
        } else {
            NSString *key = [self keyForURLString:url ofType:obj.type];
            if (!key) {
                key = url;
            }
            UIImage *image = [Cache imageForKey:key];
            [obj.object dataProvider:self didLoadImage:image fromURL:url];
        }
    }];
    [_downloader removeTaskWithURL:url];
    [t.watchers removeAllObjects];
    [self.dataProviderTasks removeObjectForKey:url];
}


- (void)downloader:(id)downloader didDownloadDataToURL:(NSURL *)tempURL sourceURL:(NSString *)sourceURL {
    // получаю таску
    ImageDataProviderTask *t = self.dataProviderTasks[sourceURL];
    
    // сохраняю исходник ВСЕГДА
    [Cache setDataFromLocalPath:tempURL forKey:sourceURL];
    
    // перебираем вотчеров и смотрим какие еще типы кроме исходника запрошены
    [t.watchers enumerateObjectsUsingBlock:^(Watcher * _Nonnull w, BOOL * _Nonnull stop) {
        ImageType type = w.type;
        if (ImageTypeNormal != type && ![Cache dataExistForKey:[self keyForURLString:sourceURL ofType:type]]) {
            [self postprocessImageForURLString:sourceURL withType:type];
        }
    }];
}

- (void)downloader:(id)downloader didFinishDownloadingURL:(NSString *)url withError:(NSError *)error {
    [self callWatchersForURLString:url withError:error];
}

@end
