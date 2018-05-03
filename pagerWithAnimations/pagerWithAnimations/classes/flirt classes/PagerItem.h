//
//  PagerItem.h
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PagerItem : NSObject
@property (nonatomic) NSInteger itemType;
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSString *itemImageUrl;
+(instancetype)newPagerItemWithType:(NSInteger)type title:(NSString *)title descr:(NSString *)descr image:(NSString *)imageUrl;
+(instancetype)newPagerItemWithType:(NSInteger)type title:(NSString *)title descr:(NSString *)descr;
+(instancetype)newPagerItemWithTitle:(NSString *)title descr:(NSString *)descr xibName:(NSString *)name;
@end
