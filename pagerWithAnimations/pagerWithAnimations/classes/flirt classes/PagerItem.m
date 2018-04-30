//
//  PagerItem.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PagerItem.h"

@implementation PagerItem

+(instancetype)newPagerItemWithType:(NSInteger)type title:(NSString *)title descr:(NSString *)descr {
    return [self newPagerItemWithType:type title:title descr:descr image:nil];
}

+(instancetype)newPagerItemWithType:(NSInteger)type title:(NSString *)title descr:(NSString *)descr image:(NSString *)imageUrl {
    PagerItem *item = [PagerItem new];
    item.itemTitle = title;
    item.itemDescription = descr;
    item.itemImageUrl = imageUrl;
    return item;
}

@end
