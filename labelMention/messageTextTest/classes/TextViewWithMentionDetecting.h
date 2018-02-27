//
//  TextViewWithMentionDetecting.h
//  messageTextTest
//
//  Created by Victor Zinets on 2/26/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageTextStorageDelegate <NSObject>
// этот метод дернется, когда будет найдено @abc и при этом курсор в конце строки
- (void)textStorage:(id)sender didFindMention:(NSString *)mention;
// этот метод будет дергаться (фактически постоянно?) если нет совпадений
- (void)textStorageHasntMention:(id)sender;
@end

@interface TextViewWithMentionDetecting : UITextView
@property (nonatomic, weak) id <MessageTextStorageDelegate> mentionDelegate;
// если у нас в введенной строке в позиции курсова (короче в конце строки) есть часть имени (@An к примеру) - заменить его на fullMention (например @Anna которое будет выбрано из списка)
- (void)replaceLastMentionWith:(NSString *)fullMention;
@end
