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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CountdownControl *counter;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet CountdownDigit *testDigit;

@end

@implementation ViewController {
    NSTimeInterval remainingTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testDigit.numericValue = 2;
    
    remainingTime = 605;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
}

- (IBAction)onIncCounter:(id)sender {
    
    self.testDigit.numericValue++;
}

- (IBAction)reset:(id)sender {
    self.testView.transform = CGAffineTransformIdentity;
}
- (IBAction)move1:(id)sender {
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformRotate(t, M_PI_4);
    t = CGAffineTransformTranslate(t, 100, 0);
    
    self.testView.transform = t;
}

- (IBAction)move2:(id)sender {
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, 100, 0);
    t = CGAffineTransformRotate(t, M_PI_4);
    
    self.testView.transform = t;
}

- (void)timer {
    self.counter.remainingTime = remainingTime--;
}

@end
