//
//  DataSource.m
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "DataSource.h"
#import "DailyMessages.h"

@implementation DataSource {
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

- (NSArray *)addMessages:(NSArray <MessageModel *> *)newMessages {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:newMessages.count];
    
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
        
        if (section == NSNotFound) { // новый день
            [result addObject:[NSIndexPath indexPathForRow:0 inSection:messagesGroupedByDay.count]];
            [messagesGroupedByDay addObject:[[DailyMessages alloc] initWithMessages:@[newMessage]]];
        } else {
            NSInteger newIndex = [messagesGroupedByDay[section] addObject:newMessage];
            [result addObject:[NSIndexPath indexPathForRow:newIndex inSection:section]];
        }
    }];
    
    return result;
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

@end
