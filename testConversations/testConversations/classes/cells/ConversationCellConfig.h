//
// Created by Zinets Viktor on 1/9/18.
// Copyright (c) 2018 Zinets Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ConversationCellTypeSingle,
    ConversationCellTypeFirst,
    ConversationCellTypeMiddle,
    ConversationCellTypeLast,
} ConversationCellType;

typedef enum {
    MessageTypeText,
    MessageTypePhoto,
    MessageTypeVideo,
} MessageType;

@interface ConversationCellConfig : NSObject
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic) ConversationCellType cellType;
@property (nonatomic) BOOL isOwnMessage;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic) MessageType messageType;
// предполагает немного другой диз с показом скриннейма/аватарки
@property (nonatomic) BOOL isConversationPublic;
@end