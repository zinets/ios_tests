//
//  CollectionViewCell.h
//  NYQ
//
//  Created by Zinets Victor on 12/18/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+MUIColor.h"

@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UILabel *lbl;
@end
