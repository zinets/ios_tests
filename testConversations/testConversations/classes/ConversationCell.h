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
@property (nonatomic, strong) NSString *messageDate;

@property (nonatomic) BOOL isOwnMessage;
@property (nonatomic) ConversationCellType cellType;
@property (nonatomic, strong) UIColor *balloonBackgroundColor;
@end

@interface ConversationMessageCell : ConversationCell
@property (nonatomic, strong) NSString *message;
@end

@interface ConversationPhotoCell : ConversationCell
@property (nonatomic, strong) NSString *photoUrl;
@end
