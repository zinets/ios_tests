//
//  ViewController.m
//  weeksTimer
//
//  Created by Zinets Viktor on 11/15/17.
//  Copyright © 2017 Zinets Viktor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSDateFormatter *df;
}
@property (weak, nonatomic) IBOutlet UIVisualEffectView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nowDate;
@property (weak, nonatomic) IBOutlet UILabel *restLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentView.alpha = 0;
    
    df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.yyyy (HH:mm)"];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1 animations:^{
        self.contentView.alpha = 1;
    }];
}

#pragma mark timer

- (void)onTimer:(id)timer {
    self.nowDate.text = [df stringFromDate:[NSDate date]];
}

- (NSString *)restText {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];

    return nil;
}

@end
