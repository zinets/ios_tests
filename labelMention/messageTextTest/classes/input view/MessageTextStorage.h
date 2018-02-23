//
//  MessageTextStorage.h
//
//  Created by Zinets Victor on 2/22/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageTextStorageDelegate <NSObject>
- (void)textStorage:(id)sender didFindMention:(NSString *)mention;
@end

@interface MessageTextStorage : NSTextStorage {
    NSMutableAttributedString *storage;
}
@property (nonatomic, weak) id <MessageTextStorageDelegate> mentionDelegate;
@end
