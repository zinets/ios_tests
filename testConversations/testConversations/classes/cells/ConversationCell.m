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
    BOOL _isScreennameVisible;
}

@property (nonatomic, strong) NSString *screenname;
@property (nonatomic, strong) NSString *avatarUrl;

@property (nonatomic) ConversationCellType cellType;
@property (nonatomic, strong) UIColor *balloonBackgroundColor;

@property (nonatomic) BOOL isOwnMessage;
// влияет на дизайн (чужого сообщения): балун сдвигается; появляется аватарка и скриннейм в 1й ячейке группы
@property (nonatomic) BOOL isScreennameVisible;

// IBuilder
@property (nonatomic, weak) IBOutlet RoundedView *messageBalloon;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *screennameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixedLeftOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixedRightOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatLeftOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatRightOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fixedTopOffset;

@end

@implementation ConversationCell

- (void)applyConfig:(ConversationCellConfig *)config {
    self.isOwnMessage = config.isOwnMessage;
    self.cellType = config.cellType;

    self.isScreennameVisible = config.isConversationPublic;
    self.screenname = config.screenname;
    self.avatarUrl = config.avatarUrl;
}

#pragma mark - overrides

- (void)awakeFromNib {
    [super awakeFromNib];
    self.balloonBackgroundColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:NO animated:NO];
}

#pragma mark setters

- (void)setBalloonBackgroundColor:(UIColor *)balloonBackgroundColor {
    _balloonBackgroundColor = balloonBackgroundColor;
    self.messageBalloon.backgroundColor = _balloonBackgroundColor;
    [self setupCell];
}

- (void)setScreenname:(NSString *)screenname {
    _screenname = screenname;
    _screennameLabel.text = _screenname;
}

- (void)setAvatarUrl:(NSString *)avatarUrl {
    _avatarUrl = avatarUrl;
    self.avatarView.image = [UIImage imageNamed:_avatarUrl];
}

- (void)setIsOwnMessage:(BOOL)isOwnMessage {
    _isOwnMessage = isOwnMessage;
    [self setupCell];
}

- (void)setIsScreennameVisible:(BOOL)isScreennameVisible {
    _isScreennameVisible = isScreennameVisible;
    [self setupCell];
}

- (BOOL)isScreennameVisible {
    return _isScreennameVisible && !self.isOwnMessage;
}

- (void)setCellType:(ConversationCellType)cellType {
    _cellType = cellType;
    [self setupCell];
}

- (void)setupCell {
    // форма
    static UIRectCorner const ownFirstCellCorners = UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerTopRight;
    static UIRectCorner const ownMiddleCellCorners = (UIRectCornerBottomLeft | UIRectCornerTopLeft);
    static UIRectCorner const ownLastCellCorners = (UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerBottomRight);
    static UIRectCorner const ownSingleCellCorners = UIRectCornerAllCorners;

    static UIRectCorner const userFirstCellCorners = (UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft);
    static UIRectCorner const userMiddleCellCorners = (UIRectCornerTopRight | UIRectCornerBottomRight);
    static UIRectCorner const userLastCellCorners = (UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft);
    static UIRectCorner const userSingleCellCorners = UIRectCornerAllCorners;

    UIRectCorner t;
    switch (self.cellType) {
        case ConversationCellTypeFirst:
            t = self.isOwnMessage ? ownFirstCellCorners : userFirstCellCorners;
            break;
        case ConversationCellTypeMiddle:
            t = self.isOwnMessage ? ownMiddleCellCorners : userMiddleCellCorners;
            break;
        case ConversationCellTypeLast:
            t = self.isOwnMessage ? ownLastCellCorners : userLastCellCorners;
            break;
        case ConversationCellTypeSingle:
        default:
            t = self.isOwnMessage ? ownSingleCellCorners : userSingleCellCorners;
            break;
    }
    self.messageBalloon.corners = t;

    // цвет
    self.messageBalloon.isBorderVisible = !self.isOwnMessage;

    // avatar/screenname
    self.avatarView.hidden = !self.isScreennameVisible;
    self.screennameLabel.hidden = !self.isScreennameVisible;

    // положение
    // балун выравнивается так: 16 пк к одной стороне и 100 или больше к другой; но свои/чужие сообщения - к правой/левой границам
    CGFloat const leftOffset = 16;
    CGFloat const avatarSize = 36;
    if (self.isOwnMessage) {
        self.fixedLeftOffset.priority = 1;
        self.floatRightOffset.priority = 1;

        self.fixedRightOffset.priority = 999;
        self.floatLeftOffset.priority = 999;
    } else {
        self.fixedRightOffset.priority = 1;
        self.floatLeftOffset.priority = 1;

        self.fixedLeftOffset.priority = 999;
        self.fixedLeftOffset.constant = leftOffset + (!self.isScreennameVisible ? 0 : (leftOffset + avatarSize));
        self.floatRightOffset.priority = 999;
    }
    // у балуна всегда 4 пк отступ снизу и 4 пк сверху - но если там балун от другой "группы" (т.е. другой юзер или другая дата)
    CGFloat topOffset = (self.cellType == ConversationCellTypeFirst || self.cellType == ConversationCellTypeSingle) ? 0 : 4;
    // и надо еще втулить скриннейм - но не для своих сообщений
    if (self.isScreennameVisible && !self.isOwnMessage) {
        topOffset += 18 + 4; // место скриннейма
    }
    self.fixedTopOffset.constant = topOffset;
}

@end

@interface ConversationMessageCell()
@property (nonatomic, strong) NSString *message;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@end

@implementation ConversationMessageCell

- (void)applyConfig:(ConversationCellConfig *)config {
    [super applyConfig:config];
    self.message = config.message;
}

-(void)setMessage:(NSString *)message {
    _message = message;

    self.messageLabel.text = _message;
}

@end

@interface ConversationPhotoCell()
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@end

@implementation ConversationPhotoCell

- (void)applyConfig:(ConversationCellConfig *)config {
    [super applyConfig:config];
    self.photoUrl = config.photoUrl;
}

- (void)setPhotoUrl:(NSString *)photoUrl {
    _photoUrl = photoUrl;
    self.photoView.image = [UIImage imageNamed:photoUrl];
}

- (void)setupCell {
    [super setupCell];
    self.messageBalloon.isBorderVisible = NO;
}

@end

@interface ConversationVideoCell()
@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, weak) IBOutlet UIImageView *videoView;
@end

@implementation ConversationVideoCell

- (void)applyConfig:(ConversationCellConfig *)config {
    [super applyConfig:config];
    self.videoUrl = config.videoUrl;
}

- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = videoUrl;
    // todo
    self.videoView.image = [UIImage imageNamed:videoUrl];
}

- (void)setupCell {
    [super setupCell];
    self.messageBalloon.isBorderVisible = NO;
}

@end