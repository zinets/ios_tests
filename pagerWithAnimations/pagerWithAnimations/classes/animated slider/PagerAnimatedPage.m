//
// Created by Victor Zinets on 5/2/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import "PagerAnimatedPage.h"


@interface PagerAnimatedPage()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *boxes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic) BOOL contentIsHidden;
@end

@implementation PagerAnimatedPage {

}

-(void)setTitleText:(NSString *)titleText {
    self.titleLabel.text = titleText;
}

-(void)setDescriptionText:(NSString *)descriptionText {
    self.descriptionLabel.text = descriptionText;
}

#pragma mark animation -

// magic numbers
CGFloat const distance = 160;
CGFloat const scaleFactor = 0.5;
CGFloat const rotationAngle = M_PI; // для вращения в нужную сторону есть отдельная магия

- (CGAffineTransform)boxRightTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, distance, 0);
    transform = CGAffineTransformRotate(transform, -rotationAngle * 1.09);
    transform = CGAffineTransformScale(transform, scaleFactor, scaleFactor);

    return transform;
}

- (CGAffineTransform)boxLeftTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -distance, 0);
    transform = CGAffineTransformScale(transform, scaleFactor, scaleFactor);
    transform = CGAffineTransformRotate(transform, -rotationAngle * .99);

    return transform;
}

- (CGAffineTransform)labelLeftTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -distance, 0);

    return transform;
}

- (CGAffineTransform)labelRightTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, distance, 0);

    return transform;
}

CGFloat const delayBetweenBoxes = 0.04;
CGFloat const springDamp = .95;
CGFloat const sprintVelocity = 20;

- (void)changeBoxesTransformFrom:(CGAffineTransform)fromTransform to:(CGAffineTransform)toTransform
                           delay:(NSTimeInterval)delay
                   reversedOrder:(BOOL)reversed {
    BOOL removing = CGAffineTransformIsIdentity(fromTransform);
    CGFloat fromAlpha = removing ? 1 : 0; //CGAffineTransformIsIdentity(fromTransform) ? 1 : 0;
    CGFloat toAlpha = removing ? 0 : 1;   //fromAlpha ? 0 : 1;
    NSArray <UIView *> *array = reversed ? [[self.boxes reverseObjectEnumerator] allObjects] : self.boxes;
    [array enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = fromTransform;
        box.alpha = fromAlpha;
        [UIView animateWithDuration:.6
                              delay:delay + delayBetweenBoxes * idx
             usingSpringWithDamping:springDamp
              initialSpringVelocity:sprintVelocity
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             box.transform = toTransform;
                             box.alpha = toAlpha;
                         } completion:nil];
    }];
}

- (void)changeLabelsTransformFrom:(CGAffineTransform)fromTransform to:(CGAffineTransform)toTransform delay:(NSTimeInterval)delay{
    CGFloat fromAlpha = CGAffineTransformIsIdentity(fromTransform) ? 1 : 0;
    CGFloat toAlpha = fromAlpha ? 0 : 1;
    [self.labels enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = fromTransform;
        box.alpha = fromAlpha;
        [UIView animateWithDuration:.6
                              delay:delay
             usingSpringWithDamping:springDamp
              initialSpringVelocity:sprintVelocity
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
        [self changeBoxesTransformFrom:[self boxLeftTransform] to:(CGAffineTransformIdentity) delay:delayBetweenBoxes * _boxes.count reversedOrder:YES];
        [self changeLabelsTransformFrom:[self labelLeftTransform] to:(CGAffineTransformIdentity) delay:0.15];
    }
}

- (void)addFromRight {
    if (_contentIsHidden) {
        _contentIsHidden = NO;
        [self changeBoxesTransformFrom:[self boxRightTransform] to:(CGAffineTransformIdentity) delay:delayBetweenBoxes * _boxes.count reversedOrder:NO];
        [self changeLabelsTransformFrom:[self labelRightTransform] to:(CGAffineTransformIdentity) delay:0.15];
    }
}

- (void)removeToRight {
    if (!_contentIsHidden) {
        _contentIsHidden = YES;
        [self changeBoxesTransformFrom:(CGAffineTransformIdentity) to:[self boxRightTransform] delay:0 reversedOrder:YES];
        [self changeLabelsTransformFrom:(CGAffineTransformIdentity) to:[self labelRightTransform] delay:0];
    }
}

- (void)removeToLeft {
    if (!_contentIsHidden) {
        _contentIsHidden = YES;
        [self changeBoxesTransformFrom:(CGAffineTransformIdentity) to:[self boxLeftTransform] delay:0 reversedOrder:NO];
        [self changeLabelsTransformFrom:(CGAffineTransformIdentity) to:[self labelLeftTransform] delay:0];
    }
}

@end
