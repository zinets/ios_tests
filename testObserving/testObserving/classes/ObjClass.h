//
//  ObjClass.h
//  testObserving
//
//  Created by Victor Zinets on 11/1/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjClass : NSObject
@property (nonatomic, strong) NSMutableArray <NSString *> *msgs;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSDate *conversationDate;

- (void)addMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
