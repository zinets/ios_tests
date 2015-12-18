//
//  CollectionViewCell.m
//  NYQ
//
//  Created by Zinets Victor on 12/18/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIColor+MUIColor.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor colorWithHex:random()];
}

@end
