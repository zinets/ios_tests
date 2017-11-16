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
    self.restLabel.text = [self restText];
}

- (NSString *)restText {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *nowDate = [NSDate date];
    {
//        components.year = 2017;
//        components.month = 11;
//        components.day = 20;
//        nowDate = [calendar dateFromComponents:components];
    }
    components.year = [calendar component:NSCalendarUnitYear fromDate:nowDate];
    components.month = 12;
    components.day = 25;
    NSDate *cDate = [calendar dateFromComponents:components];

//    components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:nowDate toDate:cDate options:0];
    NSLog(@"now %@", nowDate);
    NSLog(@"target %@", cDate);
    components = [calendar components:(NSCalendarUnitDay) fromDate:nowDate toDate:cDate options:0];
    NSLog(@"<> %@", components);
    NSInteger remainDays = components.day;
    
    switch ([nowDate compare:cDate]) {
        case NSOrderedAscending: {
            NSInteger w = remainDays / 7;
            NSInteger d = remainDays % 7;
            if (d) {
                return [NSString stringWithFormat:@"%@ недель и %@ дня(ей)", @(w), @(d)];
            } else {
                return [NSString stringWithFormat:@"%@ недель", @(w)];
            }
        }
        case NSOrderedSame:
            return @"Ровно 5 недель";
        case NSOrderedDescending:
            return @"Очень долго";
    }
    return nil;
}

@end
