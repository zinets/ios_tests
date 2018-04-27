//
//  ViewController.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 4/27/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "SPager.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *boxes;
@property (weak, nonatomic) IBOutlet SPager *pager;

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

-(void)addBoxes {
    [self.boxes enumerateObjectsUsingBlock:^(UIView *box, NSUInteger idx, BOOL *stop) {
        box.transform = CGAffineTransformMakeTranslation(200, -15);
        box.alpha = 0;
        [UIView animateWithDuration:0.4 delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
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

        [UIView animateWithDuration:0.4 delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            box.transform = CGAffineTransformMakeTranslation(-200, -15);
            box.alpha = 0;
        } completion:^(BOOL finished) {

        }];
    }];
}

@end
