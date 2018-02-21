//
//  MentionLabel.h
//  messageTextTest
//
//  Created by Zinets Victor on 2/19/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MentionLabel : UILabel
@property (nonatomic, strong) IBInspectable UIColor *mentionColor;
@property (nonatomic, strong) IBInspectable UIColor *mentionTextColor;
@property (nonatomic) IBInspectable CGFloat mentionCornerRadius;
@property (nonatomic) IBInspectable CGFloat mentionPadding;
@end
