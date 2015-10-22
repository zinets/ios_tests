//
//  ViewController.m
//  testPhotoScroller
//
//  Created by Zinets Victor on 9/15/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "SegmentedPhotoScroller.h"

@interface ViewController () <SegmentedPhotoScrollerDataSource, SegmentedPhotoScrollerDelegate> {
    SegmentedPhotoScroller *_photoScroller;
    BOOL fullScreen;
    NSArray *dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataSource = @[@[@"g0.jpg",@"g1.jpg",@"g2.jpg",@"g3.jpg",@"g4.jpg",@"g5.jpg",@"g6.jpg",@"g7.jpg",@"g8.jpg",@"g9.jpg",],
                   @[@"a0.jpg",@"a1.jpg",@"a2.jpg",@"a3.jpg"]
                   ];
    
    _photoScroller = [[SegmentedPhotoScroller alloc] initWithFrame:(CGRect){{0, 20}, {320, 240}}];
    _photoScroller.dataSource = self;
    _photoScroller.delegate = self;
    
    UIView *centerView = [[UIView alloc] initWithFrame:(CGRect){{0, 0}, {102, 102}}];
    centerView.backgroundColor = [UIColor redColor];
    centerView.layer.cornerRadius = 51;
    centerView.layer.borderWidth = 2;
    _photoScroller.centerView = centerView;
    
    [self.view addSubview:_photoScroller];
    [_photoScroller reloadData];
    
    [_photoScroller startDemoMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scroller datasource

- (NSInteger)numberOfSectionsForScroller:(id)sender {
    return dataSource.count;
}
- (NSInteger)scroller:(id)sender numberOfItemsInSection:(NSInteger)section {
    return [dataSource[section] count];
}

- (NSString *)scroller:(id)sender imageUrlForIndexPath:(NSIndexPath *)indexPath {
    return dataSource[indexPath.section][indexPath.item];
}

- (BOOL)scroller:(id)sender isBlurredItemAtIndexPath:(NSIndexPath *)indexpath {
    return indexpath.section > 0;
}

#pragma mark - scroller delegate

-(void)scroller:(SegmentedPhotoScroller *)sender didSelectItemAtIndexPath:(NSIndexPath *)indexpath {
    fullScreen = !fullScreen;
    if (!fullScreen) {
        sender.frame = (CGRect){{0, 20}, {320, 240}};
    } else {
        sender.frame = self.view.bounds;
    }
    [sender presentItemAtIndex:indexpath fullscreen:fullScreen];
}

-(void)centerViewDidSelect:(SegmentedPhotoScroller *)sender {
    fullScreen = YES;
    sender.frame = self.view.bounds;
    [sender presentItemAtIndex:nil fullscreen:fullScreen];
}


@end
