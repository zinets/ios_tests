//
//  DataSource.h
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface DataSource : NSObject
-(NSInteger)numberOfMessages;
-(MessageModel *)messageAtIndex:(NSInteger)index;
@end
