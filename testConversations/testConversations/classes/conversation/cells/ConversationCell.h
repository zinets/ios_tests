//
//  ConversationCell.h
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConversationCellConfig.h"

@interface ConversationCell : UITableViewCell
- (void)applyConfig:(ConversationCellConfig *)config;
@end

@interface ConversationMessageCell : ConversationCell
@end

@interface ConversationPhotoCell : ConversationCell
@end

@interface ConversationVideoCell : ConversationCell
@end

@interface ConversationHeader : UITableViewHeaderFooterView
@property (nonatomic, strong) NSString *headerText;
@end
