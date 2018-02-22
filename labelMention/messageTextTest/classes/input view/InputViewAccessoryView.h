//
//  InputViewAccessoryView.h
//  messageTextTest
//
//  Created by Zinets Victor on 2/22/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentionedUser : NSObject
@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *avatarUrl;
+(instancetype)userWithName:(NSString *)screenname avatar:(NSString *)avatar;
@end

@protocol InputViewAccessoryViewDelegate <NSObject>
- (void)accessoryView:(id)sender didSelectItemAtIndex:(NSInteger)index;
@end

@interface InputViewAccessoryView : UIView
@property (nonatomic, strong) NSArray <MentionedUser *> *dataSource;
@property (nonatomic, weak) id <InputViewAccessoryViewDelegate> delegate;
@end
