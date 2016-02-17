//
//  StackCell.h
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIColor+MUIColor.h"
#import "UIView+Geometry.h"

static NSString *const reuseIdStackCell = @"stjswrg";

@interface StackCell : UICollectionViewCell
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *images;
/// идея "глубины" - это параметр от 0 до 1, который меняет прозрачность и трансформ ячейки (скейл и смещение)
@property (nonatomic, assign) CGFloat depth;
@end
