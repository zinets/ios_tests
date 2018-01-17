//
//  UsersListViewController.h
//  testConversations
//
//  Created by Zinets Viktor on 1/17/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConversationUsersListDelegate <NSObject>
- (void)listWantsShowAllUsersList:(id)sender;
#warning что передавать, юзерИнфо? а что будет в items то и передавать
- (void)list:(id)sender wantsShowUser:(id)user;
@end

@interface ConversationUsersListViewController : UIViewController
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) IBOutlet id <ConversationUsersListDelegate> delegate;
@end
