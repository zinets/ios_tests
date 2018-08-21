//
//  THCache.m
//  THCache
//
//  Created by Eugene Zhuk on 03.09.14.
//  Copyright (c) 2014 yarra. All rights reserved.
//

#import "Cache.h"
@import MD5;


@implementation Cache
#pragma mark - private
+ (NSString *)diskCachePath {
    static NSString *diskCachePath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *folder = @"com.togethernetworks.cache";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = [paths[0] stringByAppendingPathComponent:folder];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:diskCachePath]) {
            BOOL success = [fileManager createDirectoryAtPath:diskCachePath withIntermediateDirectories:YES attributes:nil error:NULL];
            if (!success) {
#ifdef DEBUG
                NSLog(@"TNCache WARNING: Cache directory creation error!");
#endif
            }
        }
    });
    return diskCachePath;
}

+ (NSString *)fullDataPathForKey:(NSString *)key {
    return [[self diskCachePath] stringByAppendingFormat:@"/%@", [MD5Generator md5:key]];
}

#pragma mark - cache
+ (void)setData:(NSData *)data forKey:(NSString *)key {
    if (data && key) {
        NSString *path = [self fullDataPathForKey:key];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            BOOL success = [fileManager createFileAtPath:path contents:data attributes:nil];
            if (!success) {
#ifdef DEBUG
                NSLog(@"TNCache WARNING: File creation error: %@", key);
#endif
            }
        }
    }
}

+ (void)setDataFromLocalPath:(NSURL *)location forKey:(NSString *)key {
    if (location && key) {
        NSString *path = [self fullDataPathForKey:key];
        NSURL *destination = [NSURL fileURLWithPath:path];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path]) {
            NSError *error;
            BOOL success = [fileManager copyItemAtURL:location toURL:destination error:&error];
            if (!success || error) {
#ifdef DEBUG
                NSLog(@"TNCache WARNING: File creation error: %@ --- %@", key, error);
#endif
            }
        }
    }
}

+ (NSData *)dataForKey:(NSString *)key {
    NSString *path = [self fullDataPathForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager contentsAtPath:path];
}

+ (UIImage *)imageForKey:(id)key {
    NSData *data = [self dataForKey:key];
    return [[UIImage alloc] initWithData:data];
}

+ (BOOL)dataExistForKey:(NSString *)key {
    NSString *path = [self fullDataPathForKey:key];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

@end
