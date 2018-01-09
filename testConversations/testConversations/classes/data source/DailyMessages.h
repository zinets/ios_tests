//
// Created by Zinets Viktor on 1/9/18.
// Copyright (c) 2018 Zinets Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "ConversationCellConfig.h"

// это массив сообщений за 1 день; в таблице с перепиской это одна секция
@interface DailyMessages : NSObject
- (instancetype)initWithMessages:(NSArray <MessageModel *> *)messages;

- (NSInteger)numberOfMessages;
- (ConversationCellConfig *)configOfCellAtIndex:(NSInteger)index;
- (NSDate *)date;
@end