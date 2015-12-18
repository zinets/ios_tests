//
//  CollectionViewCell.m
//  NYQ
//
//  Created by Zinets Victor on 12/18/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIColor+MUIColor.h"

@implementation CollectionViewCell {    
    __weak IBOutlet UIImageView *_imageView;
}

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor colorWithHex:random()];
}

-(void)setImage:(UIImage *)image {
    _imageView.backgroundColor = [UIColor colorWithHex:random()];
}

@end
