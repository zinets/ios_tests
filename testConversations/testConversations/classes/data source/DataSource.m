//
//  DataSource.m
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "DataSource.h"
#import "DailyMessages.h"

@interface DataSource() <DailyMessagesDelegate>
@end

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
        if (section == NSNotFound) { // новый день
            obj = [DailyMessages new];
            obj.delegate = self;
            [messagesGroupedByDay addObject:obj];
        } else {
            obj = messagesGroupedByDay[section];
        }
        [obj addObjects:@[newMessage]];
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

- (void)sender:(id)sender didAddItems:(NSIndexSet *)indexes {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, indexes);
}

- (void)sender:(id)sender didUpdateItems:(NSIndexSet *)indexes {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, indexes);
}


@end
