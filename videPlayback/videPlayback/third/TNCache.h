//
//  TNCache.h
//  TNCache
//
//  Created by Eugene Zhuk on 03.09.14.
//  Copyright (c) 2014 yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNCache : NSObject
+ (BOOL)dataExistForKey:(NSString *)key;

+ (void)setData:(NSData *)data forKey:(NSString *)key;
+ (NSData *)dataForKey:(NSString *)key;
+ (UIImage *)imageForKey:(NSString *)key;

+ (void)setDataFromLocalPath:(NSURL *)location forKey:(NSString *)key;
@end
