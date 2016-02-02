//
//  CollectionViewCell.m
//  testCollectionModes
//
//  Created by Zinets Victor on 1/29/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "CollectionViewCell.h"

#import "Utils.h"
#import "UIColor+MUIColor.h"
#import "UIImage+Thumbnails.h"

@implementation CollectionViewCell {
    UILabel *lbl;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor colorWithHex:random() & 0x00ffffff];
        
        _photoView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _photoView.contentMode = UIViewContentModeTop;
        _photoView.clipsToBounds = YES;
        [self.contentView addSubview:_photoView];
        
        lbl = [[UILabel alloc] initWithFrame:(CGRect){{5, 5}, {100, 15}}];
        lbl.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:lbl];
        
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:(CGRect){{5, 25}, {150, 15}}];
        lbl2.numberOfLines = 0;
        lbl2.font = [UIFont boldSystemFontOfSize:11];
        lbl2.textColor = [UIColor redColor];
        lbl2.text = [NSString stringWithFormat:@"addr:\n%p", self];
        [lbl2 sizeToFit];
        [self.contentView addSubview:lbl2];
        
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setTitle:(NSString *)title {
    lbl.text = title;
}

- (void)setPhoto:(UIImage *)photo {
    if (![photo isEqual:_photo]) {
        _photo = photo;
        
        CGFloat duration = 0.4;
        CATransition *fading = [CATransition animation];
        fading.duration = duration;
        fading.type = kCATransitionFade;
        
        UIImage *img = [_photo fillFromTopInSize:_photoView.frame.size];
        _photoView.image = img;
        
        //    [_photoView.layer addAnimation:fading forKey:@"f"];
    }
}

#pragma mark -

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    CGFloat duration = 0.4;
    if (_photo) {
        [UIView animateWithDuration:duration animations:^{
            [self layoutIfNeeded];
            
            _photoView.contentMode = UIViewContentModeScaleAspectFill;
            _photoView.frame = self.bounds;
            UIImage *img = [_photo fillFromTopInSize:layoutAttributes.frame.size];
            _photoView.image = img;
        } completion:^(BOOL finished) {
            _photoView.contentMode = UIViewContentModeTop;
        }];
    }
}

@end

@implementation CollectionViewCellExt

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.contentView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    }
    return self;
}

@end