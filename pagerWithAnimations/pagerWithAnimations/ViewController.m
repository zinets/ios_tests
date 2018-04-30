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


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeBoxes];

}

- (IBAction)onTap:(id)sender {
    [self addBoxes];
}
- (IBAction)ontap2:(id)sender {
    [self removeBoxes];
}

- (CGAffineTransform)rightTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 160, 0);
    transform = CGAffineTransformRotate(transform, -M_PI * 1.09);
    transform = CGAffineTransformScale(transform, 0.5, 0.5);

    return transform;
}

- (CGAffineTransform)leftTransform {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, -160, 0);
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    transform = CGAffineTransformRotate(transform, -M_PI * .99);
    
    return transform;
}

-(void)addBoxes {
    [self.boxes enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = [self rightTransform];
        box.alpha = 0;
        [UIView animateWithDuration:0.6
                              delay:0.05 * idx
             usingSpringWithDamping:0.95
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            box.transform = CGAffineTransformIdentity;
            box.alpha = 1;
        } completion:^(BOOL finished) {

        }];
        
    }];
}

-(void)removeBoxes {
    [self.boxes enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = CGAffineTransformIdentity;
        box.alpha = 1;

        [UIView animateWithDuration:.6
                              delay:0.05 * idx
             usingSpringWithDamping:0.95
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             box.transform = [self leftTransform];
            box.alpha = 0;
        } completion:^(BOOL finished) {

        }];
    }];
}

- (IBAction)addFromLeft {
    [self changeTransformFrom:[self leftTransform] to:(CGAffineTransformIdentity)];
}

- (IBAction)addFromRight {
    [self changeTransformFrom:[self rightTransform] to:(CGAffineTransformIdentity)];
}
- (IBAction)removeToRight:(id)sender {
    [self changeTransformFrom:(CGAffineTransformIdentity) to:[self rightTransform]];
}

- (IBAction)removeToLeft:(id)sender {
    [self changeTransformFrom:(CGAffineTransformIdentity) to:[self leftTransform]];
}

- (void)changeTransformFrom:(CGAffineTransform)fromTransform to:(CGAffineTransform)toTransform {
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

@end
