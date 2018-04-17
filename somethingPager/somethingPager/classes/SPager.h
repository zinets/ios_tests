//
//  SPager.h
//  somethingPager
//
//  Created by Victor Zinets on 4/16/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagerItem : NSObject
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemDescription;
@property (nonatomic, strong) NSString *itemImageUrl;
+(instancetype)newPagerItemWithTitle:(NSString *)title descr:(NSString *)descr image:(NSString *)imageUrl;
@end

@interface SPager : UIView
@property (nonatomic, strong) NSArray <PagerItem *> *dataSource;

@property (nonatomic) NSInteger currentPage;
@end
