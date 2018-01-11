//
//  DataSource.h
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@class DailyMessages;

@interface DataSource : NSObject 
- (NSInteger)numberOfSections;
- (DailyMessages *)messagesOfSectionAtIndex:(NSInteger)section;

- (void)addMessages:(NSArray <MessageModel *> *)newMessages;
@end
