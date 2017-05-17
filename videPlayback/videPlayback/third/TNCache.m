//
//  THCache.m
//  THCache
//
//  Created by Eugene Zhuk on 03.09.14.
//  Copyright (c) 2014 yarra. All rights reserved.
//

#import "TNCache.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TNCache
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
    return [[self diskCachePath] stringByAppendingFormat:@"/%@", [self cachedFileNameForKey:key]];
}

+ (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];

    return filename;
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
