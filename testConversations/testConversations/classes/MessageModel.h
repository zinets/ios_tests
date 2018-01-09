//
//  MessageModel.h
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *messageDate;
@property (nonatomic, strong) NSString *photoUrl;

@property (nonatomic) BOOL ownMessage;
@end
