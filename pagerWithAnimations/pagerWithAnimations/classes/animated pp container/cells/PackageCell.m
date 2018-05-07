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
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel2;


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
    
    self.continueButton.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.1].CGColor;
    self.continueButton.layer.shadowOffset = (CGSize){0, 3};
    self.continueButton.layer.shadowOpacity = 1;
    
}

#pragma mark setters -

-(void)setDuration:(NSString *)duration {
    _durationLabel.text = duration;
}

-(void)setPrice:(NSString *)price {
    _priceLabel.text = price;
}

-(void)setSalePart1:(NSString *)salePart1 {
    _saleLabel1.text = salePart1;
}

-(void)setSalePart2:(NSString *)salePart2 {
    _saleLabel2.text = salePart2;
}

@end
