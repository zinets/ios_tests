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
}

- (void)viewDidLoad {
    [super viewDidLoad];
       
    remainingTime = 605;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
    self.likePack.isCountdownVisible = YES;
    self.testDigit.font = [UIFont systemFontOfSize:80 weight:(UIFontWeightBold)];
    
}

- (IBAction)tap:(id)sender {
    [self timer];
}

- (void)timer {
//    self.counter.remainingTime = remainingTime;//self.counter.remainingTime + 671;
    self.likePack.countdownRemainingTime = remainingTime;
    self.testDigit.numericValue = remainingTime++;
}

@end
