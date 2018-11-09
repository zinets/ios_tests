//
//  BlindHorizBaraban.h
//  autoCollectionCell
//
//  Created by Victor Zinets on 11/8/18.
//  Copyright © 2018 TN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BlindHorizBarabanDelegate <NSObject>
- (void)baraban:(id)sender didSelectItemAt:(NSInteger)index;
@end

IB_DESIGNABLE
@interface BlindHorizBaraban : UIView
@property (nonatomic, strong) IBInspectable UIColor *headerTextColor;
@property (nonatomic, strong) IBInspectable NSString *headerText;

@property (nonatomic, strong) NSArray <NSString *> *items;
@property (nonatomic, weak) id<BlindHorizBarabanDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
