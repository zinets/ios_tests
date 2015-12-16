//
//  CollectionViewCell.m
//  supplTest
//
//  Created by Zinets Victor on 12/15/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIColor+MUIColor.h"

@implementation CollectionViewCell {
    UILabel *lbl;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        lbl = [[UILabel alloc] initWithFrame:CGRectInset(self.contentView.bounds, 5, 5)];
        lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        lbl.numberOfLines = 0;
        [self.contentView addSubview:lbl];
        
        self.backgroundColor = [UIColor colorWithHex:random() & 0xffffff];
    }
    return self;
}

-(void)setText:(NSString *)text {
    _text = text;
    lbl.text = _text;
}

@end
