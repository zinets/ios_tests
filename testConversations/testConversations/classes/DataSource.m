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




- (void)initDatasource {
    MessageModel *m = [MessageModel new]; {
        m.screenName = @"Sierra";
        m.message = @"Wow.";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-10000];
        m.ownMessage = NO;
        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.screenName = @"Sierra";
        m.message = @"So what is going on?";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-10000+100];
        m.ownMessage = NO;
        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.screenName = @"anime girl";
        m.message = @"We had a meth addict in here this morning who @Max was biologically younger";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-10000+150];
        m.ownMessage = YES;
        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.screenName = @"anime girl";
        m.message = @"We had a meth addict in here this morning who                       was biologically younger";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-10000+200];
        m.ownMessage = YES;
        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.screenName = @"Sierra";
        m.message = @"Kidney function, liver function";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-10000+250];
        m.ownMessage = NO;
        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];
}

@end
