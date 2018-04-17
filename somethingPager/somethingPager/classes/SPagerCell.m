//
//  SPagerCell.m
//  somethingPager
//
//  Created by Victor Zinets on 4/16/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "SPagerCell.h"

@interface SPagerCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;

@end

@implementation SPagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark setters -

-(void)setItemTitle:(NSString *)itemTitle {
    self.itemTitleLabel.text = itemTitle;
}

-(void)setItemImageUrl:(NSString *)itemImageUrl {
    self.itemImageView.image = [UIImage imageNamed:itemImageUrl];
}

-(void)setItemDescription:(NSString *)itemDescription {
    self.itemDescriptionLabel.text = itemDescription;
}

@end
