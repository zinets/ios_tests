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

- (NSDate *)dateFromString:(NSString *)strDate {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm"];

    return [dateFormat dateFromString:strDate];
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
        m.message = @"5 We had a meth addict in here this morning who was biologically younger.";
        m.messageDate = [self dateFromString:@"08.01.2018 13:34"];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
//        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"6";
        m.messageDate = [self dateFromString:@"08.01.2018 17:34"];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
//        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
        m.photoUrl = @"img1.jpg";
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
}

@end
