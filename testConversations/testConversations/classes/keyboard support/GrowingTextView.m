//
//  GrowingTextView.m
//
//  Created by Zinets Viktor on 1/15/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "GrowingTextView.h"

@interface GrowingTextView ()
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation GrowingTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.firstAttribute == NSLayoutAttributeHeight) {
                if (constraint.relation == NSLayoutRelationEqual) {
                    self.heightConstraint = constraint;
                    self.heightConstraint.priority = 750; // она должна быть меньше, чем ограничители сверху-снизу
                }
            }
        }        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize sz = [self sizeThatFits:self.frame.size];
//    CGFloat h = ((int)sizeThatFits.height / 22) * 22; // так можно сделать высоту контрола "кратной" значению 22 - как в дизе
    CGFloat h = sz.height
    self.heightConstraint.constant = h;
}

@end
