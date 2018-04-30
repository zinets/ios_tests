//
//  PagerAnimatedCell.h
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/30/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagerAnimatedCell : UICollectionViewCell 
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *descriptionText;

@property (nonatomic) BOOL contentIsHidden;
- (void)addFromLeft;
- (void)addFromRight;
- (void)removeToRight;
- (void)removeToLeft;
@end
