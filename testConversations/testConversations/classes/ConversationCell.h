//
//  ConversationCell.h
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ConversationCellTypeSingle,
    ConversationCellTypeFirst,
    ConversationCellTypeMiddle,
    ConversationCellTypeLast,
} ConversationCellType;

@interface ConversationCell : UITableViewCell
// todo remove date
@property (nonatomic, strong) NSString *messageDate;
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *avatarUrl;

@property (nonatomic) ConversationCellType cellType;
@property (nonatomic, strong) UIColor *balloonBackgroundColor;

@property (nonatomic) BOOL isOwnMessage;
// влияет на дизайн (чужого сообщения): балун сдвигается; появляется аватарка и скриннейм в 1й ячейке группы
@property (nonatomic) BOOL isScreennameVisible;
@end

@interface ConversationMessageCell : ConversationCell
@property (nonatomic, strong) NSString *message;
@end

@interface ConversationPhotoCell : ConversationCell
@property (nonatomic, strong) NSString *photoUrl;
@end
