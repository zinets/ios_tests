//
//  ViewController.m
//  testInfiniteScroller2
//
//  Created by Zinetz Victor on 07.03.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "ViewController.h"

#import "InfiniteScroller.h"

@interface ViewController () <InfiniteScrollerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    InfiniteScroller * scroller = [[InfiniteScroller alloc] initWithFrame:CGRectMake(10, 10, 96 * 4, 310)];
    scroller.backgroundColor = [UIColor lightGrayColor];
    scroller.dataSource = self;
    [scroller reloadData];
    [self.view addSubview:scroller];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)scrollerItemsCount:(InfiniteScroller *)scroller {
    return 2;
}

-(UIView *)scroller:(InfiniteScroller *)scroller viewForIndex:(NSInteger)index reuseView:(UIView *)view {
    if (view == nil) {
        view = [[UILabel alloc] init];
        view.backgroundColor = RGB3(random());
    }
    ((UILabel *)view).text = [NSString stringWithFormat:@"lbl %d", index];
    
    return view;
}

@end
