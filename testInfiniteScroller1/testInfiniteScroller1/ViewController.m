//
//  ViewController.m
//  testInfiniteScroller1
//
//  Created by Zinetz Victor on 3/7/13.
//  Copyright (c) 2013 Zinetz Victor. All rights reserved.
//

#import "ViewController.h"
#import "InfiniteScroller.h"

#define RGB3(color)  [UIColor colorWithRed:((color & 0xff0000) >> 16) / 255.0f \
green:((color & 0xff00) >> 8) / 255.0f \
blue:(color & 0xff) / 255.0f \
alpha:1.0]

@interface ViewController () <InfiniteScrollerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    InfiniteScroller * scroller = [[InfiniteScroller alloc] initWithFrame:CGRectMake(10, 10, 600, 500)];
    scroller.dataSource = self;
    scroller.cellSize = 140;
    [self.view addSubview:scroller];
    [scroller reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - datasource

-(NSInteger)scrollerItemsCount:(InfiniteScroller *)scroller {
    return 13;
}

-(UIView *)scroller:(InfiniteScroller *)scroller viewForIndex:(NSInteger)index reuseView:(UIView *)view {
    if (!view) {
        view = [[UILabel alloc] init];
        view.backgroundColor = RGB3(random());
    }
    ((UILabel *)view).text = [NSString stringWithFormat:@"lbl %d", index];
    
    return view;
}

@end
