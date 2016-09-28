//
//  ImageSelectorListCell.m
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ImageSelectorListCell.h"

#define SIDE_INSET 20.0

@implementation ImageSelectorListCell {
    UILabel *_textLabel;
    UIView *_separator;
    UIImageView *_imageView;
}

+ (CGFloat)cellHeight {
    return 60;
}


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.separator];
    }
    return self;
}

#pragma mark - getters

-(UILabel *)textLabel {
    if (!_textLabel) {
        CGRect frm = self.contentView.bounds;
        frm.origin.x = SIDE_INSET;
        frm.size.width -= 2 * SIDE_INSET;
        _textLabel = [[UILabel alloc] initWithFrame:frm];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        // надо кастомизить - кастомизь снаружи
    }
    return _textLabel;
}

-(UIView *)separator {
    if (!_separator) {
        _separator = [[UIView alloc] initWithFrame:(CGRect){{SIDE_INSET, self.contentView.bounds.size.height - 0.5},
            {self.contentView.bounds.size.width - 2 * SIDE_INSET, 0.5}}];
        _separator.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _separator.backgroundColor = [UIColor lightGrayColor];
    }
    return _separator;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

-(void)setIconImage:(UIImage *)iconImage {
    if (iconImage) {
        self.imageView.image = iconImage;
        [self.imageView sizeToFit];
        CGRect frm = self.imageView.frame;
        frm.origin.x = self.contentView.bounds.size.width - SIDE_INSET - frm.size.width;
        frm.origin.y = (self.bounds.size.height - frm.size.height) / 2;
        
        self.imageView.frame = frm;
        [self.contentView addSubview:self.imageView];
    }
    
    self.textLabel.textAlignment = iconImage == nil ? NSTextAlignmentCenter : NSTextAlignmentLeft;
}

@end
