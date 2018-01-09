//
//  MessageModel.m
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (MessageType)messageType {
    MessageType res = MessageTypeText;
    if (self.videoUrl) {
        res = MessageTypeVideo;
    } else if (self.photoUrl) {
        res = MessageTypePhoto;
    }
    return res;
}

@end