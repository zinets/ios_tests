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
// только для теста, цыфра на ячейке
@property (nonatomic) NSInteger itemIndex;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic) UIViewContentMode imageContentMode;
@end
