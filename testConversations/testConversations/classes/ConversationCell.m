//
//  ConversationCell.m
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "ConversationCell.h"
#import "RoundedView.h"

@interface ConversationCell() {

}
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageDateLabel;
@property (nonatomic, weak) IBOutlet RoundedView *messageBalloon;
@end

@implementation ConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.balloonBackgroundColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];
}

#pragma mark setters

- (void)setBalloonBackgroundColor:(UIColor *)balloonBackgroundColor {
    _balloonBackgroundColor = balloonBackgroundColor;
    self.messageBalloon.backgroundColor = _balloonBackgroundColor;
    [self setupCell];
}

-(void)setMessage:(NSString *)message {
    _message = message;
    
    self.messageLabel.text = _message;
}

-(void)setMessageDate:(NSString *)messageDate {
    _messageDate = messageDate;
    self.messageDateLabel.text = _messageDate;
}

- (void)setIsOwnMessage:(BOOL)isOwnMessage {
    _isOwnMessage = isOwnMessage;
    [self setupCell];
}

- (void)setCellType:(ConversationCellType)cellType {
    _cellType = cellType;
    [self setupCell];
}

- (void)setupCell {
    // форма
    UIRectCorner t;
    switch (self.cellType) {
        case ConversationCellTypeFirst:
            t = self.isOwnMessage ? (UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerTopRight) : (UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft);
            break;
        case ConversationCellTypeMiddle:
            t = self.isOwnMessage ? (UIRectCornerBottomLeft | UIRectCornerTopLeft) : (UIRectCornerTopRight | UIRectCornerBottomRight);
            break;
        case ConversationCellTypeLast:
            t = self.isOwnMessage ? (UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerBottomRight) : (UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft);
            break;
        case ConversationCellTypeSingle:
        default:
            t = UIRectCornerAllCorners;
            break;
    }
    self.messageBalloon.corners = t;

    // цвет
    self.messageBalloon.isBorderVisible = !self.isOwnMessage;
}

@end
