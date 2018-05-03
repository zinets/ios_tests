//
// Created by Victor Zinets on 5/2/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalPageIndicator.h"
#import "UIColor+MUIColor.h"

#import "PagerItem.h"

@interface PagerWithAnimatedPages : UIView
@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray <PagerItem *> *dataSource;
- (void)startAnimating;
- (void)stopAnimating;

@end
