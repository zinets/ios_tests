//
//  SPagerCell.m
//  somethingPager
//
//  Created by Victor Zinets on 4/16/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "SPagerCell.h"
#import "UIColor+MUIColor.h"

@interface SPagerCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionLabel;

@end

@implementation SPagerCell

-(void)prepareForReuse {
    self.itemImageView.image = nil;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
#warning // todo настройка пресетом отключена "шоб собралось""
//    [self.itemTitleLabel applyPresetsFor:iePPTitleLabel];
    // пресетами никак (платежка МШ и ИЧ ИСПОЛЬЗУЕТ ОДИН И ТОТ ЖЕ ПРЕСЕТ, А ДИЗ ХОЧЕТ 2 РАЗНЫХ ЦВЕТА) и мать его доводить до ума
    self.itemTitleLabel.textColor = [UIColor whiteColor];

//    [self.itemDescriptionLabel applyPresetsFor:iePPDescriptionLabel];
    self.itemDescriptionLabel.textColor = [UIColor colorWithHex:0xaaaaaa];
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
