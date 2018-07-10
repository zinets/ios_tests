//
//  ViewController.m
//  likepackProto
//
//  Created by Victor Zinets on 6/19/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "ViewController.h"
#import "CountdownControl.h"
#import "CountdownDigit.h"
#import "LikepackCardsControl.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CountdownControl *counter;
@property (weak, nonatomic) IBOutlet LikepackCardsControl *likePack;
@property (weak, nonatomic) IBOutlet CountdownDigit *testDigit;

@end

@implementation ViewController {
    NSTimeInterval remainingTime;
    CGPoint viewCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
       
    remainingTime = 605;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
    self.likePack.isCountdownVisible = NO;
    self.likePack.image = [UIImage imageNamed:@"Online_18-24_female"];
    self.testDigit.font = [UIFont systemFontOfSize:80 weight:(UIFontWeightBold)];
    
    viewCenter = self.likePack.center;
}

- (IBAction)tap:(id)sender {
//    [self timer];
    static CGFloat pos = 1;
    [self moveView:self.likePack position:pos];
    pos = -pos;
}

- (void)timer {
//    self.counter.remainingTime = remainingTime;//self.counter.remainingTime + 671;
    self.likePack.countdownRemainingTime = remainingTime;
    self.testDigit.numericValue = remainingTime++;
}

- (IBAction)onChange:(UISlider *)sender {
    [self moveView:self.likePack position:sender.value];
}

typedef enum {
    MoveDirectionRight,
    MoveDirectionLeft,
} MoveDirection;

- (void)moveView:(UIView *)viewToMove direction:(MoveDirection)direction {
    
        [self moveView:viewToMove position:direction == MoveDirectionLeft ? -.2 : .2];
    
}

- (void)moveView:(UIView *)view position:(CGFloat)position {
    CGFloat const radius = 1000;
    CGFloat const angle = (M_PI / 6) * position;
    
    CGFloat x = sin(angle) * radius;
    CGFloat y = (radius - cos(angle) * radius);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, x, y);
    transform = CGAffineTransformRotate(transform, angle);
    [UIView animateWithDuration:0.5 animations:^{
        self.likePack.transform = transform;
    }];
}

@end
