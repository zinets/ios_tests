//
// Created by Zinets Viktor on 1/9/18.
// Copyright (c) 2018 Zinets Viktor. All rights reserved.
//

#import "DailyMessages.h"

@implementation DailyMessages {    
    NSMutableArray <ConversationCellConfig *> *array;
    NSDate *messagesDate;
}

typedef enum {
    CellStateUndef,
    CellStateOwn,
    CellStateUser,
} CellState;

- (instancetype)initWithMessages:(NSArray <MessageModel *> *)messages {
    if (self = [super init]) {
        array = [NSMutableArray arrayWithCapacity:messages.count];
        
        [self updateConfigsForMessages:messages];
    }
    return self;
}

- (void)updateConfigsForMessages:(NSArray <MessageModel *> *)messages {
    NSArray *sortedArray = [messages sortedArrayUsingComparator:^NSComparisonResult(MessageModel *obj1, MessageModel *obj2) {
        return [obj1.messageDate compare:obj2.messageDate];
    }];
    
    for (int x = 0; x < sortedArray.count; x++) {
        MessageModel *obj = sortedArray[x];
        ConversationCellConfig *config = [ConversationCellConfig new];
        
        config.screenname = obj.screenName;
        config.avatarUrl = obj.avatarUrl;
        
        // визуальное группирование потом
        config.cellType = ConversationCellTypeUndef;
        
        config.isOwnMessage = obj.ownMessage;
        config.message = obj.message;
        config.photoUrl = obj.photoUrl;
        config.videoUrl = obj.videoUrl;
        if (!messagesDate) {
            messagesDate = obj.messageDate;
        }
        config.messageDate = obj.messageDate;
        
        MessageType res = MessageTypeText;
        if (obj.videoUrl) {
            res = MessageTypeVideo;
        } else if (obj.photoUrl) {
            res = MessageTypePhoto;
        }
        config.messageType = res;
        config.isConversationPublic = YES;
        
        [array addObject:config];
    }
    [self updateGrouping];
}

- (void)updateGrouping { // делегаты, новые состояния, обновленные состояния
    CellState prevState, curState, nextState;
    prevState = curState = nextState = CellStateUndef;
    for (int x = 0; x < array.count; x++) {
        ConversationCellConfig *config = array[x];
        
        if (array.count == 1) {
            config.cellType = ConversationCellTypeSingle;
        } else {
            if (x + 1 < array.count) {
                ConversationCellConfig *obj_next = array[x + 1];
                nextState = obj_next.isOwnMessage ? CellStateOwn : CellStateUser;
            }
            curState = config.isOwnMessage ? CellStateOwn : CellStateUser;
            if (x == 0 || prevState != curState) {
                // possible first
                if (nextState == curState) {
                    config.cellType = ConversationCellTypeFirst;
                } else {
                    config.cellType = ConversationCellTypeSingle;
                }
            } else {
                // possible middle
                if (nextState == curState) {
                    config.cellType = ConversationCellTypeMiddle;
                } else {
                    config.cellType = ConversationCellTypeLast;
                }
            }
        }
        prevState = curState;
        nextState = CellStateUndef;
    }
}

- (NSInteger)addObject:(MessageModel *)message {
    ConversationCellConfig *config = [ConversationCellConfig new];
    
    config.screenname = message.screenName;
    config.avatarUrl = message.avatarUrl;
    
    // визуальное группирование потом
    config.cellType = ConversationCellTypeUndef;
    
    config.isOwnMessage = message.ownMessage;
    config.message = message.message;
    config.photoUrl = message.photoUrl;
    config.videoUrl = message.videoUrl;
    if (!messagesDate) {
        messagesDate = message.messageDate;
    }
    config.messageDate = message.messageDate;
    
    MessageType res = MessageTypeText;
    if (message.videoUrl) {
        res = MessageTypeVideo;
    } else if (message.photoUrl) {
        res = MessageTypePhoto;
    }
    config.messageType = res;
    config.isConversationPublic = YES;
    
    [array addObject:config];
    [self updateGrouping];
    
    return array.count - 1;
}

- (NSDate *)date {
    return messagesDate;
}

- (NSInteger)numberOfMessages {
    return [array count];
}
- (ConversationCellConfig *)configOfCellAtIndex:(NSInteger)index {
    return array[index];
}
@end
