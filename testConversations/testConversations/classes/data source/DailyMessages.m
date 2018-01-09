//
// Created by Zinets Viktor on 1/9/18.
// Copyright (c) 2018 Zinets Viktor. All rights reserved.
//

#import "DailyMessages.h"

@implementation DailyMessages {
    NSMutableArray <ConversationCellConfig *> *array;
    NSDate *messagesDate;
}

- (instancetype)initWithMessages:(NSArray <MessageModel *> *)messages {
    if (self = [super init]) {
        array = [NSMutableArray arrayWithCapacity:messages.count];

        NSArray *sortedArray = [messages sortedArrayUsingComparator:^NSComparisonResult(MessageModel *obj1, MessageModel *obj2) {
            return [obj1.messageDate compare:obj2.messageDate];
        }];

        [sortedArray enumerateObjectsUsingBlock:^(MessageModel *obj, NSUInteger idx, BOOL *stop) {
            ConversationCellConfig *config = [ConversationCellConfig new];

            config.screenname = obj.screenName;
            config.avatarUrl = obj.avatarUrl;
            // todo
            config.cellType = ConversationCellTypeSingle;
            // todo: не надо ли убрать из MessageModel ownMessage?
            config.isOwnMessage = obj.ownMessage;
            config.message = obj.message;
            config.photoUrl = obj.photoUrl;
            config.videoUrl = obj.videoUrl;
            if (!messagesDate) {
                messagesDate = obj.messageDate;
            }
            MessageType res = MessageTypeText;
            if (obj.videoUrl) {
                res = MessageTypeVideo;
            } else if (obj.photoUrl) {
                res = MessageTypePhoto;
            }
            config.messageType = res;

            [array addObject:config];
        }];
    }
    return self;
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