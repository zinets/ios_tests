//
// Created by Victor Zinets on 5/2/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import "PagerAnimatedCell2.h"

@interface PagerAnimatedCell2()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *boxes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation PagerAnimatedCell2 {

}

- (IBAction)removeToLeftAction:(id)sender {
    [self removeToLeft];
}

- (IBAction)addFromLeft:(id)sender {
    [self addFromRight];
}

-(void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

-(void)setDescriptionText:(NSString *)descriptionText {
    self.descriptionLabel.text = descriptionText;
}

#pragma mark animation -

- (CGAffineTransform)boxRightTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 160, 0);
    transform = CGAffineTransformRotate(transform, -M_PI * 1.09);
    transform = CGAffineTransformScale(transform, 0.5, 0.5);

    return transform;
}

- (CGAffineTransform)boxLeftTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -160, 0);
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    transform = CGAffineTransformRotate(transform, -M_PI * .99);

    return transform;
}

- (CGAffineTransform)labelLeftTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -160, 0);

    return transform;
}

- (CGAffineTransform)labelRightTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 160, 0);

    return transform;
}

- (void)changeBoxesTransformFrom:(CGAffineTransform)fromTransform to:(CGAffineTransform)toTransform {
    [self changeBoxesTransformFrom:fromTransform to:toTransform delay:0];
}

- (void)changeBoxesTransformFrom:(CGAffineTransform)fromTransform to:(CGAffineTransform)toTransform delay:(NSTimeInterval)delay {
    CGFloat fromAlpha = CGAffineTransformIsIdentity(fromTransform) ? 1 : 0;
    CGFloat toAlpha = fromAlpha ? 0 : 1;
    [self.boxes enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = fromTransform;
        box.alpha =  fromAlpha;
        [UIView animateWithDuration:.6
                              delay:delay + 0.05 * idx
             usingSpringWithDamping:0.95
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             box.transform = toTransform;
                             box.alpha = toAlpha;
                         } completion:nil];
    }];
}

- (void)changeLabelsTransformFrom:(CGAffineTransform)fromTransform to:(CGAffineTransform)toTransform {
    [self changeLabelsTransformFrom:fromTransform to:toTransform delay:0];
}

- (void)changeLabelsTransformFrom:(CGAffineTransform)fromTransform to:(CGAffineTransform)toTransform delay:(NSTimeInterval)delay{
    CGFloat fromAlpha = CGAffineTransformIsIdentity(fromTransform) ? 1 : 0;
    CGFloat toAlpha = fromAlpha ? 0 : 1;
    [self.labels enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = fromTransform;
        box.alpha =  fromAlpha;
        [UIView animateWithDuration:.6
                              delay:delay + 0.05 * idx
             usingSpringWithDamping:0.95
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             box.transform = toTransform;
                             box.alpha = toAlpha;
                         } completion:nil];
    }];
}

- (void)addFromLeft {
    if (_contentIsHidden) {
        _contentIsHidden = NO;
        [self changeBoxesTransformFrom:[self boxLeftTransform] to:(CGAffineTransformIdentity)];
        [self changeLabelsTransformFrom:[self labelLeftTransform] to:(CGAffineTransformIdentity)];
    }
}

- (void)addFromRight {
    if (_contentIsHidden) {
        _contentIsHidden = NO;
        [self changeBoxesTransformFrom:[self boxRightTransform] to:(CGAffineTransformIdentity)];
        [self changeLabelsTransformFrom:[self labelRightTransform] to:(CGAffineTransformIdentity)];
    }
}

- (void)removeToRight {
    if (!_contentIsHidden) {
        _contentIsHidden = YES;
        [self changeBoxesTransformFrom:(CGAffineTransformIdentity) to:[self boxRightTransform]];
        [self changeLabelsTransformFrom:(CGAffineTransformIdentity) to:[self labelRightTransform]];
    }
}

- (void)removeToLeft {
    if (!_contentIsHidden) {
        _contentIsHidden = YES;
        [self changeBoxesTransformFrom:(CGAffineTransformIdentity) to:[self boxLeftTransform] delay:0.1];
        [self changeLabelsTransformFrom:(CGAffineTransformIdentity) to:[self labelLeftTransform]];
    }
}

@end
