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

@end

@implementation ViewController {
    NSTimeInterval remainingTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
       
    remainingTime = 605;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
}

- (void)timer {
    self.counter.remainingTime = remainingTime--;
}

@end
