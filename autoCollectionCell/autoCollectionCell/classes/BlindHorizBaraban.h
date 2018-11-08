//
//  BlindHorizBaraban.h
//  autoCollectionCell
//
//  Created by Victor Zinets on 11/8/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlindHorizBaraban : UIView
@property (nonatomic, strong) UIColor *headerTextColor;
@property (nonatomic, strong) NSString *headerText;

@property (nonatomic, strong) NSArray <NSString *> *items;

@end

NS_ASSUME_NONNULL_END
