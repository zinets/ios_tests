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

@protocol ConversationDataSourceDelegate <NSObject>
@optional
- (void)sender:(id)sender didAddSections:(NSIndexSet *)sections;
- (void)sender:(id)sender didUpdateSections:(NSIndexSet *)sections;
- (void)sender:(id)sender didAddItems:(NSArray <NSIndexPath *> *)indexes;
- (void)sender:(id)sender didUpdateItems:(NSArray <NSIndexPath *> *)indexes;
@end

@interface ConversationDataSource : NSObject 
- (NSInteger)numberOfSections;
- (DailyMessages *)messagesOfSectionAtIndex:(NSInteger)section;

- (void)addMessages:(NSArray <MessageModel *> *)newMessages;
- (void)removeAllMessages;

@property (nonatomic, weak) id <ConversationDataSourceDelegate> delegate;
@property (nonatomic) BOOL isConversationPublic;
@end
