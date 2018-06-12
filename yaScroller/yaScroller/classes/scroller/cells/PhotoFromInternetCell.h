//
//  PhotoFromInternetCell.h
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoFromInternet.h"

@interface PhotoFromInternetCell : UICollectionViewCell
@property (nonatomic, strong) PhotoFromInternet *data;
@property (nonatomic) BOOL fs;
@property (nonatomic) NSInteger itemIndex;
@end
