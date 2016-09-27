//
//  ImageSorceButtonCellTableViewCell.m
//  Flirt
//
//  Created by Eugene Zhuk on 7/20/16.
//  Copyright © 2016 Yarra. All rights reserved.
//

#import "ImageSorceButtonCellTableViewCell.h"
#import "UIView+Geometry.h"

@interface ImageSorceButtonCellTableViewCell ()
{
    CALayer *_separator;
}
@end

@implementation ImageSorceButtonCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        
        _separator = [CALayer layer];
        [self.layer addSublayer:_separator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    
    if (self.icon) {
        self.textLabel.left = 20;
        self.imageView.right = self.imageView.superview.width - 20;
    } else {
        self.textLabel.centerX = self.textLabel.superview.width/2;
    }
    
    self.textLabel.top = 17;
    self.imageView.centerY = self.textLabel.centerY;
    
    _separator.backgroundColor = _separatorColor.CGColor;
    _separator.frame = (CGRect){{20, self.layer.frame.size.height}, {self.layer.frame.size.width - 20*2, 0.5}};
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.textLabel.text = title;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.imageView.image = icon;
}

@end
