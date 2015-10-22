//
//  ViewController.m
//  testInfiniteScroller
//
//  Created by Zinetz Victor on 05.03.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Geometry.h"
#import "InfiniteScroller.h"

@interface ViewController () <InfiniteScrollerDataSource> {
    InfiniteScroller * scroller;
}

@end

#define RGB3(color)  [UIColor colorWithRed:((color & 0xff0000) >> 16) / 255.0f \
green:((color & 0xff00) >> 8) / 255.0f \
blue:(color & 0xff) / 255.0f \
alpha:1.0]
@implementation ViewController

-(NSInteger)infiniteScrollerItemsCount:(InfiniteScroller *)scroller {
    return 11;
}

-(UIView *)infiniteScroller:(InfiniteScroller *)scroller viewForIndex:(NSInteger)index {
    UILabel * view = (UILabel * )[scroller dequeueReusableView];
    if (!view) {
        view = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    view.text = [NSString stringWithFormat:@"lbl %d", index];
    view.backgroundColor = RGB3(random());
    
    return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scroller = [[InfiniteScroller alloc] initWithFrame:CGRectMake(200, self.view.height - 370, 220, 370)];
    scroller.layer.borderColor = [UIColor redColor].CGColor;
    scroller.layer.borderWidth = 1;
    [self.view addSubview:scroller];
    scroller.dataSource = self;
    [scroller reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
