//
//  Watcher.h
//  TNURLImageView
//
//  Created by Alexandr Dikhtyar on 5/24/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDataProviderDelegate.h"
#import "TNImageTypes.h"


@interface Watcher : NSObject

@property (nonatomic, readonly) id <ImageDataProviderDelegate> object;
@property (nonatomic, readonly) ImageType type;

- (instancetype)initWithObject:(id<ImageDataProviderDelegate>)object type:(ImageType)type;

@end
