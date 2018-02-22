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
    [super setSelected:NO animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:NO animated:NO];
}

-(void)setScreenName:(NSString *)screenName {
    _screenName = screenName;
    self.screennameLabel.text = _screenName;
}

-(void)setAvatarUrl:(NSString *)avatarUrl {
    _avatarUrl = avatarUrl;
    // todo load url
    self.avatarView.image = [UIImage imageNamed:_avatarUrl];
}

@end
