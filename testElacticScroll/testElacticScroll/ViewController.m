//
//  ViewController.m
//  testElacticScroll
//
//  Created by Zinetz Victor on 01.10.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "ViewController.h"
#import "ElasticTableView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    ElasticTableView * _table;
    CFTimeInterval startTime;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];
    
    _table = [[ElasticTableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        borderControl(cell);
    }
    cell.layer.cornerRadius = 20;
    cell.layer.masksToBounds = YES;
    cell.textLabel.text = [NSString stringWithFormat:@"cell with #%d", indexPath.row];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UITableView *)tableView  {
    CGPoint location = [tableView.panGestureRecognizer locationInView:tableView];
    NSIndexPath * index = [tableView indexPathForRowAtPoint:location];
    
    NSLog(@"%@ %@",NSStringFromCGPoint(location), index);
    startTime = CACurrentMediaTime();
 }

- (void)scrollViewDidScroll:(UITableView *)tableView {
    float timeDifference = MIN(CACurrentMediaTime() - startTime, 0.5);
    float maxDelta = 50;
    
    NSArray * cells = [tableView visibleCells];
    NSLog(@"%d", cells.count);
    for (UITableViewCell * cell in cells) {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, timeDifference * maxDelta);
        cell.transform = transform;
    }
}

- (void)scrollViewDidEndDecelerating:(UITableView *)tableView {
    NSArray * cells = [tableView visibleCells];
    NSLog(@"end scrolling");
    [UIView animateWithDuration:0.2 animations:^{
        for (UITableViewCell * cell in cells) {
            CGAffineTransform transform = CGAffineTransformIdentity;
            cell.transform = transform;
        }
        
    }];
}

@end
