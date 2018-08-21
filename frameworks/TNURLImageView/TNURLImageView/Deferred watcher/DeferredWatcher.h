//
//  DeferredWatcher.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/24/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDataProviderDelegate.h"
#import "TNImageTypes.h"


@interface DeferredWatcher : NSObject <ImageDataProviderDelegate>

@property (nonatomic, copy, nonnull) void (^callback)(UIImage *_Nullable);

- (instancetype _Nullable)initWithType:(ImageType)type url:(NSString *_Nonnull)url;

@end
