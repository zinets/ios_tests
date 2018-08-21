//
//  DeferredWatcher.m
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/24/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import "DeferredWatcher.h"
#import "ImageDataProvider.h"


@interface DeferredWatcher ()

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, assign) ImageType type;

@end


@implementation DeferredWatcher

- (instancetype)initWithType:(ImageType)type url:(NSString *)url {
    if (self = [super init]) {
        _urlString = url;
        _type = type;
    }
    return self;
}

- (void)setCallback:(void (^)(UIImage *))callback {
    _callback = callback;
    [[ImageDataProvider sharedInstance] getImagesForUrls:@[_urlString] watcher:self imageType:_type];
}

- (void)dataProvider:(id)dataProvider didLoadImage:(UIImage *)image fromURL:(NSString *)url {
    _callback(image);
}

- (void)dataProvider:(id)dataProvider didFailLoadingImageFromURL:(NSString *)url {
    _callback(nil);
}

@end
