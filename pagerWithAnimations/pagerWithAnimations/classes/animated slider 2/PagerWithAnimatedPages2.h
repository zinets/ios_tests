//
// Created by Victor Zinets on 5/2/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalPageIndicator.h"
#import "UIColor+MUIColor.h"

@class PagerItem;

@interface PagerWithAnimatedPages2 : UIView {
    NSArray *_dataSource;
}

@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray <PagerItem *> *dataSource;
@property (nonatomic, strong) HorizontalPageIndicator *pageIndicator;
- (void)startAnimating;
- (void)stopAnimating;

@end
