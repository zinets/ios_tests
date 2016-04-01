//
//  Cell1.m
//  test_layout_switch
//
//  Created by Zinets Victor on 3/31/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Cell1.h"

@implementation Cell1 {

}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.borderWidth = 2;
        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        
        lbl = [[UILabel alloc] initWithFrame:self.bounds];
        lbl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        lbl.backgroundColor = [UIColor blueColor];
        lbl.numberOfLines = 0;
        [self.contentView addSubview:lbl];
    }
    return self;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    lbl.text = [NSString stringWithFormat:@"%@\n%d - %d", [[self class] description], layoutAttributes.indexPath.section, layoutAttributes.indexPath.item];
    [self layoutIfNeeded]; 
}

@end
