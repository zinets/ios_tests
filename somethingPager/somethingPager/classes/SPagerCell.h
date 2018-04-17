//
//  SPagerCell.h
//  somethingPager
//
//  Created by Victor Zinets on 4/16/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPagerCell : UICollectionViewCell
@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *itemImageUrl;
@property (nonatomic, strong) NSString *itemDescription;
@end
