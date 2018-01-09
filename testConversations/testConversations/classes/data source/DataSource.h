//
//  DataSource.h
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@class DailyMessages;

@interface DataSource : NSObject
- (NSInteger)numberOfSections;
- (DailyMessages *)messagesOfSectionAtIndex:(NSInteger)section;
@end
