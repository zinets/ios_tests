//
//  DataSource.m
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource {
    NSMutableArray <MessageModel *> *data;
    NSMutableDictionary <NSDate *, id> *sortedData;
}

-(instancetype)init {
    if (self = [super init]) {
        data = [NSMutableArray array];
        [self initDatasource];
    }
    return self;
}

-(NSInteger)numberOfMessages {
    return data.count;
}

-(MessageModel *)messageAtIndex:(NSInteger)index {
    return data[index];
}

- (void)initDatasource {
    NSString *ownScreenname = @"Sierra";
    NSString *userScreenname = @"anime girl";

    MessageModel *m = [MessageModel new]; {
        m.message = @"1 Wow.";
        m.messageDate = [self dateFromString:@"25.12.2017 13:34"];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
//        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"2 So what is going on?";
        m.messageDate = [self dateFromString:@"31.12.2017 13:34"];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
//        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"3 We had a meth addict in here this morning who @Max was biologically younger.";
        m.messageDate = [self dateFromString:@"31.12.2017 19:34"];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
//        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
    }

    [data addObject:m];
    m = [MessageModel new]; {
        m.message = @"4";
        m.messageDate = [self dateFromString:@"07.01.2018 13:34"];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
//        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
        m.photoUrl = @"img2.jpg";
    }
    [data addObject:m];



    
    m = [MessageModel new]; {
        m.message = @"own message 1";
        m.messageDate = [self dateFromString:@"08.01.2018 10:00"];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
    }
    [data addObject:m];

    m = [MessageModel new]; {
        m.message = @"own message 2";
        m.messageDate = [self dateFromString:@"08.01.2018 12:10"];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
    }
    [data addObject:m];

    m = [MessageModel new]; {
        m.message = @"own message 3";
        m.messageDate = [self dateFromString:@"08.01.2018 14:00"];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
    }
    [data addObject:m];

    m = [MessageModel new]; {
        m.message = @"user message 1";
        m.messageDate = [self dateFromString:@"08.01.2018 14:14"];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
    }
    [data addObject:m];

    m = [MessageModel new]; {
        m.messageDate = [self dateFromString:@"08.01.2018 14:14"];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        m.photoUrl = @"img1.jpg";
    }
    [data addObject:m];

    m = [MessageModel new]; {
        m.message = @"user message 2";
        m.messageDate = [self dateFromString:@"08.01.2018 14:25"];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
    }
    [data addObject:m];

    m = [MessageModel new]; {
        m.message = @"own message 4";
        m.messageDate = [self dateFromString:@"08.01.2018 15:00"];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
    }
    [data addObject:m];

    m = [MessageModel new]; {
        m.message = @"own message 5 (last)";
        m.messageDate = [self dateFromString:@"08.01.2018 15:05"];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
    }
    [data addObject:m];

    m = [MessageModel new]; {
        m.message = @"user message 3 (last)";
        m.messageDate = [self dateFromString:@"08.01.2018 19:25"];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"7 Kidney function, liver function.";
        m.messageDate = [self dateFromString:@"09.01.2018 13:34"];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
//        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];


    sortedData = [NSMutableDictionary dictionaryWithCapacity:100];

    __block NSDate *key = [self truncateDateTime:data[0].messageDate];
    __block NSMutableArray *messages = [NSMutableArray new];
    [data enumerateObjectsUsingBlock:^(MessageModel *obj, NSUInteger idx, BOOL *stop) {

        NSDate *truncatedDate = [self truncateDateTime:obj.messageDate];
        if ([truncatedDate isEqualToDate:key]) {
            [messages addObject:obj];


        } else {
            sortedData[key] = [messages copy];
            [messages removeAllObjects];

            key = truncatedDate;
            [messages addObject:obj];
        }
    }];

    NSLog(@"%@", sortedData);
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
