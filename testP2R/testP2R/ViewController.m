//
//  ViewController.m
//  testP2R
//
//  Created by Zinetz Victor on 23.06.14.
//  Copyright (c) 2014 Cupid plc. All rights reserved.
//

#import "ViewController.h"
#import "WBPull2Refresh.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView * _table;
    BOOL _loading;
    WBPull2Refresh * _pull2refresh;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _table = [[UITableView alloc] initWithFrame:self.view.bounds
                                          style:(UITableViewStylePlain)];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
    
    _pull2refresh = [WBPull2Refresh refreshIndicator];
    _pull2refresh.activityImage = [UIImage imageNamed:@"p2r"];
    [_table addSubview:_pull2refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cellId"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"cell number %d", indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"details about cell number %d", indexPath.row];
    
    return cell;
}

#pragma mark - delegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_pull2refresh.progress < 1) {
        _loading = NO;
    } else if (!_loading) {
        _loading = YES;
        [_pull2refresh startRefreshing];
        NSTimer * tmr = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(p2rDidEndRefreshing:) userInfo:nil repeats:NO];
    }

}

-(void)p2rDidEndRefreshing:(id)sender
{
    [_pull2refresh stopRefreshing];
    _loading = NO;
}

@end


