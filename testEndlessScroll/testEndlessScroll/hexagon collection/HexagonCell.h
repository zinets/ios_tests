//
//  HexagonCell.h
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HexagonCellData.h"

@interface HexagonCell : UICollectionViewCell
@property (nonatomic, strong) HexagonCellData *data;
@end
