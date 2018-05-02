//
// Created by Victor Zinets on 5/2/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMNibLoadedView.h"

@interface PagerAnimatedPage : RMNibLoadedView
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *descriptionText;

- (void)addFromLeft;
- (void)addFromRight;
- (void)removeToRight;
- (void)removeToLeft;
@end