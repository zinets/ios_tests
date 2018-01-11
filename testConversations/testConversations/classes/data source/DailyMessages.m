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
        
        [self addObjects:messages];
    }
    return self;
}

-(instancetype)init {
    if (self = [super init]) {
        array = [NSMutableArray array];
    }
    return self;
}

- (void)updateGrouping { // делегаты, новые состояния, обновленные состояния
    CellState prevState, curState, nextState;
    prevState = curState = nextState = CellStateUndef;
    NSMutableIndexSet *newIndexes = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *changedIndexes = [NSMutableIndexSet indexSet];
    
    void (^checkType)(NSInteger, ConversationCellType, ConversationCellType) = ^void(NSInteger index, ConversationCellType actualType, ConversationCellType newType) {
        if (actualType == ConversationCellTypeUndef) {
            [newIndexes addIndex:index];
        } else if (actualType != newType) {
            [changedIndexes addIndex:index];
        }
    };
    
    for (int x = 0; x < array.count; x++) {
        ConversationCellConfig *config = array[x];
        
        if (array.count == 1) {
            checkType(x, config.cellType, ConversationCellTypeSingle);
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
                    checkType(x, config.cellType, ConversationCellTypeFirst);
                    config.cellType = ConversationCellTypeFirst;
                } else {
                    checkType(x, config.cellType, ConversationCellTypeSingle);
                    config.cellType = ConversationCellTypeSingle;
                }
            } else {
                // possible middle
                if (nextState == curState) {
                    checkType(x, config.cellType, ConversationCellTypeMiddle);
                    config.cellType = ConversationCellTypeMiddle;
                } else {
                    checkType(x, config.cellType, ConversationCellTypeLast);
                    config.cellType = ConversationCellTypeLast;
                }
            }
        }
        prevState = curState;
        nextState = CellStateUndef;
    }
    if (self.delegate) {
        if (newIndexes.count && [self.delegate respondsToSelector:@selector(sender:didAddItems:)]) {
            [self.delegate sender:self didAddItems:newIndexes];
        }
        if (changedIndexes.count && [self.delegate respondsToSelector:@selector(sender:didUpdateItems:)]) {
            [self.delegate sender:self didUpdateItems:changedIndexes];
        }
    }
}

- (void)addObjects:(NSArray <MessageModel *> *)messages {
    [messages enumerateObjectsUsingBlock:^(MessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    }];
    array = [[array sortedArrayUsingComparator:^NSComparisonResult(ConversationCellConfig *obj1, ConversationCellConfig *obj2) {
        return [obj1.messageDate compare:obj2.messageDate];
    }] mutableCopy];
    
    [self updateGrouping];
}

- (NSDate *)date {
    return messagesDate ? : [NSDate date]; // потому что сообщений может не быть, даты еще нет, будут ошибки-ворнинги при добавлении секций
}

- (NSInteger)numberOfMessages {
    return [array count];
}
- (ConversationCellConfig *)configOfCellAtIndex:(NSInteger)index {
    return array[index];
}
@end
