//
//  GrowingTextView.m
//  testConversations
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
                if ( constraint.relation == NSLayoutRelationEqual) {
                    self.heightConstraint = constraint;
                }
            }
        }        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize sizeThatFits = [self sizeThatFits:self.frame.size];
    self.heightConstraint.constant = sizeThatFits.height;
}

@end
