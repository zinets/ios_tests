//
//  PackagesContainerLayout.h
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackagesContainerLayout : UICollectionViewLayout
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGSize selectedItemSize;
@property (nonatomic) CGFloat minimumInterItemSpacing;
@end
