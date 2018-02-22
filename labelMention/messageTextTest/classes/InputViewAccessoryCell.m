//
//  InputViewAccessoryCell.m
//  messageTextTest
//
//  Created by Zinets Victor on 2/22/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "InputViewAccessoryCell.h"

@interface InputViewAccessoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;

@end

@implementation InputViewAccessoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
