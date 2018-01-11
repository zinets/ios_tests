//
// Created by Zinets Viktor on 1/9/18.
// Copyright (c) 2018 Zinets Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "ConversationCellConfig.h"

@protocol DailyMessagesDelegate <NSObject>
@optional
- (void)sender:(id)sender didAddItems:(NSIndexSet *)indexes;
- (void)sender:(id)sender didUpdateItems:(NSIndexSet *)indexes;
@end

// это массив сообщений за 1 день; в таблице с перепиской это одна секция
@interface DailyMessages : NSObject
//- (instancetype)initWithMessages:(NSArray <MessageModel *> *)messages;
@property (nonatomic, weak) id <DailyMessagesDelegate> delegate;

- (void)addObjects:(NSArray <MessageModel *> *)messages;

- (NSInteger)numberOfMessages;
- (ConversationCellConfig *)configOfCellAtIndex:(NSInteger)index;
- (NSDate *)date;
@end
