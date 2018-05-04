//
//  PackageCell.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PackageCell.h"
#import "PackageCellLayoutAttributes.h"

@interface PackageCell()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;

@end

@implementation PackageCell

-(void)prepareForReuse {
    [self applyGrowingValue:0];
}

- (void)applyGrowingValue:(CGFloat)growingValue {
    self.alpha = MAX(0.44, growingValue);
    
    self.button.transform = CGAffineTransformMakeScale(growingValue, growingValue);
    self.buttonHeight.constant = 48 * growingValue;
    self.button.layer.cornerRadius = self.buttonHeight.constant / 2;
    
    self.button.alpha = growingValue;
}

- (void)applyLayoutAttributes:(PackageCellLayoutAttributes *)layoutAttributes {
    [self applyGrowingValue:layoutAttributes.growingPercent];
}

@end
