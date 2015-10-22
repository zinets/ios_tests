//
//  ViewController.m
//  test_p2r
//
//  Created by Zinetz Victor on 13.01.15.
//  Copyright (c) 2015 Cupid plc. All rights reserved.
//

#import "ViewController.h"
#import "Pull2RefreshControl.h"

@interface ViewController () <UIScrollViewDelegate> {
    UIScrollView * contentView;
    Pull2RefreshControl * p2rControl;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    contentView.contentSize = (CGSize){320, self.view.frame.size.height * 2};
    contentView.delegate = self;
    [self.view addSubview:contentView];
    
    p2rControl = [Pull2RefreshControl instance];

    [contentView addSubview:p2rControl];
    
    UIView * v = [UIView new];
    v.frame = (CGRect){{10, 10}, {300, 100}};
    v.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.7 alpha:1];
    [contentView addSubview:v];
    
    v = [UIView new];
    v.frame = (CGRect){{10, 150}, {300, 100}};
    v.backgroundColor = [UIColor colorWithRed:0.4 green:0.7 blue:0.5 alpha:1];
    [contentView addSubview:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshData:(UIViewController *)sender
{
    [p2rControl startRefreshing];
    [self performSelector:@selector(stopRefreshing) withObject:nil afterDelay:5.0];
}

- (void)stopRefreshing
{
    [p2rControl stopRefreshing];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (p2rControl && p2rControl.progress == 1) {
        [self refreshData:self];
    }
}

@end
