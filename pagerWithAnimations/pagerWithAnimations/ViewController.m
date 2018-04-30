//
//  ViewController.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/27/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *boxes;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

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
    CGFloat fromAlpha = CGAffineTransformIsIdentity(fromTransform) ? 1 : 0;
    CGFloat toAlpha = fromAlpha ? 0 : 1;
    [self.boxes enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = fromTransform;
        box.alpha =  fromAlpha;
        [UIView animateWithDuration:0.6
                              delay:0.05 * idx
             usingSpringWithDamping:0.95
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             box.transform = toTransform;
                             box.alpha = toAlpha;
                         } completion:nil];
    }];
}

- (void)changeLabelsTransformFrom:(CGAffineTransform)fromTransform to:(CGAffineTransform)toTransform {
    CGFloat fromAlpha = CGAffineTransformIsIdentity(fromTransform) ? 1 : 0;
    CGFloat toAlpha = fromAlpha ? 0 : 1;
    [self.labels enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = fromTransform;
        box.alpha =  fromAlpha;
        [UIView animateWithDuration:0.6
                              delay:0.05
             usingSpringWithDamping:0.95
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             box.transform = toTransform;
                             box.alpha = toAlpha;
                         } completion:nil];
    }];
}

#pragma mark testing -

- (IBAction)addFromLeft {
    [self changeBoxesTransformFrom:[self boxLeftTransform] to:(CGAffineTransformIdentity)];
    [self changeLabelsTransformFrom:[self labelLeftTransform] to:(CGAffineTransformIdentity)];
    
}

- (IBAction)addFromRight {
    [self changeBoxesTransformFrom:[self boxRightTransform] to:(CGAffineTransformIdentity)];
    [self changeLabelsTransformFrom:[self labelRightTransform] to:(CGAffineTransformIdentity)];
}
- (IBAction)removeToRight:(id)sender {
    [self changeBoxesTransformFrom:(CGAffineTransformIdentity) to:[self boxRightTransform]];
    [self changeLabelsTransformFrom:(CGAffineTransformIdentity) to:[self labelRightTransform]];
}

- (IBAction)removeToLeft:(id)sender {
    [self changeBoxesTransformFrom:(CGAffineTransformIdentity) to:[self boxLeftTransform]];
    [self changeLabelsTransformFrom:(CGAffineTransformIdentity) to:[self labelLeftTransform]];
}


@end
