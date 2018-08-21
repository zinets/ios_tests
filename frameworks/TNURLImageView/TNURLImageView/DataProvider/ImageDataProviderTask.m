//
//  ImageDataProviderTask.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/21/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "ImageDataProviderTask.h"

@implementation ImageDataProviderTask

- (instancetype)initWithURL:(NSString *)url {
    if (self = [super init]) {
        _url = url;
        _watchers = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addWatcher:(id<ImageDataProviderDelegate>)watcher forType:(ImageType)type {
    Watcher *w = [[Watcher alloc] initWithObject:watcher type:type];
    @synchronized (self) {
        if ([_watchers containsObject:w]) {
            // bypass
        } else {
            [_watchers addObject:w];
        }
    }
}

- (void)removeWatcher:(id<ImageDataProviderDelegate>)watcher {
    NSMutableSet <Watcher *> *toDelete = [NSMutableSet new];
    [_watchers enumerateObjectsUsingBlock:^(Watcher * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.object isEqual:watcher]) {
            [toDelete addObject:obj];
        }
    }];
    [_watchers minusSet:toDelete];
}

@end
