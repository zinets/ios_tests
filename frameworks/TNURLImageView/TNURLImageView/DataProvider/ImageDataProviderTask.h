//
//  ImageDataProviderTask.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDataProviderDelegate.h"
#import "Watcher.h"

@interface ImageDataProviderTask : NSObject

@property (nonatomic, readonly) NSString *url;
@property (atomic, readonly) NSMutableSet <Watcher *> *watchers;

- (instancetype)initWithURL:(NSString *)url;
- (void)addWatcher:(id<ImageDataProviderDelegate>)watcher forType:(ImageType)type;
- (void)removeWatcher:(id<ImageDataProviderDelegate>)watcher;

@end
