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
    NSString *ownScreenname = @"Sierra";
    NSString *userScreenname = @"anime girl";

    MessageModel *m = [MessageModel new]; {
        m.message = @"Wow.";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-170000];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"So what is going on?";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-16000];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"We had a meth addict in here this morning who @Max was biologically younger.";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-15000];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
    }

    [data addObject:m];
    m = [MessageModel new]; {
        m.message = @"";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-14000];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
        m.photoUrl = @"img2.jpg";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"We had a meth addict in here this morning who was biologically younger.";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-13000];
        m.ownMessage = YES;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-12000];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
        m.photoUrl = @"img1.jpg";
    }
    [data addObject:m];
    
    m = [MessageModel new]; {
        m.message = @"Kidney function, liver function.";
        m.messageDate = [NSDate dateWithTimeIntervalSinceNow:-11000];
        m.ownMessage = NO;
        m.screenName = m.ownMessage ? ownScreenname : userScreenname;
        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
    }
    [data addObject:m];
}

@end
