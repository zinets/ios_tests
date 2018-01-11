//
//  DataSource.m
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "ConversationDataSource.h"
#import "DailyMessages.h"

@interface ConversationDataSource() <DailyMessagesDelegate>
@end

@implementation ConversationDataSource {
    NSMutableArray <DailyMessages *> *messagesGroupedByDay;
}

-(instancetype)init {
    if (self = [super init]) {
        [self initDatasource];
    }
    return self;
}

- (void)initDatasource {
    messagesGroupedByDay = [NSMutableArray array]; //[NSMutableArray arrayWithCapacity:tempArrayOfMessages.count];
//    for (NSArray *arr in tempArrayOfMessages) {
//        [messagesGroupedByDay addObject:[[DailyMessages alloc] initWithMessages:arr]];
//    }
}

- (NSInteger)numberOfSections {
    return [messagesGroupedByDay count];
}

- (DailyMessages *)messagesOfSectionAtIndex:(NSInteger)section {
    return messagesGroupedByDay[section];
}

#pragma mark -

- (void)addMessages:(NSArray <MessageModel *> *)newMessages {
    [newMessages enumerateObjectsUsingBlock:^(MessageModel * _Nonnull newMessage, NSUInteger idx, BOOL * _Nonnull stop) {
        // 1) определить "день", в который надо добавить новые сообщения
        __block NSInteger section = NSNotFound;
        [messagesGroupedByDay enumerateObjectsUsingBlock:^(DailyMessages * _Nonnull dailyMessages, NSUInteger index, BOOL * _Nonnull stop) {
            NSDate *truncatedGroupDate = [self truncateDateTime:dailyMessages.date];
            NSDate *truncatedMessageDate = [self truncateDateTime:newMessage.messageDate];
            if ([truncatedGroupDate isEqualToDate:truncatedMessageDate]) {
                section = index;
                *stop = YES;
            }
        }];
        
        DailyMessages *obj;
        BOOL newSection = NO;
        if (section == NSNotFound) { // новый день
            obj = [DailyMessages new];
            obj.delegate = self;
            [messagesGroupedByDay addObject:obj];
            newSection = YES;
            
            if ([self.delegate respondsToSelector:@selector(sender:didAddSections:)]) {
                [self.delegate sender:self didAddSections:[NSIndexSet indexSetWithIndex:messagesGroupedByDay.count - 1]];
            }
        } else {
            obj = messagesGroupedByDay[section];
        }
        [obj addObjects:@[newMessage]];
        if (newSection && [self.delegate respondsToSelector:@selector(sender:didUpdateSections:)]) {
            [self.delegate sender:self didUpdateSections:[NSIndexSet indexSetWithIndex:messagesGroupedByDay.count - 1]];
        }
    }];
}

#pragma mark - dates

- (NSDate *)dateFromString:(NSString *)strDate {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm"];

    return [dateFormat dateFromString:strDate];
}

- (NSDate *)truncateDateTime:(NSDate *)dateTime {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit flags = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *components = [cal components:flags fromDate:dateTime];

    return [cal dateFromComponents:components];
}

#pragma mark delegation

- (void)sender:(DailyMessages *)sender didAddItems:(NSIndexSet *)indexes {
    if ([self.delegate respondsToSelector:@selector(sender:didAddItems:)] && indexes.count) {
        NSInteger section = [messagesGroupedByDay indexOfObject:sender];
        if (section != NSNotFound) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:indexes.count];
            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
            }];
            
            [self.delegate sender:self didAddItems:arr];
        }
    }
}

- (void)sender:(DailyMessages *)sender didUpdateItems:(NSIndexSet *)indexes {
    if ([self.delegate respondsToSelector:@selector(sender:didUpdateItems:)] && indexes.count) {
        NSInteger section = [messagesGroupedByDay indexOfObject:sender];
        if (section != NSNotFound) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:indexes.count];
            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:[NSIndexPath indexPathForRow:idx inSection:section]];
            }];
            
            [self.delegate sender:self didUpdateItems:arr];
        }
    }
}


@end
