//
//  ViewController.m
//  navbarHiding
//
//  Created by Zinets Victor on 8/7/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "NavBarHiding.h"

typedef NS_ENUM(NSUInteger, ScrollingState) {
    StateScrollingNone,
    StateScrollingDown,
    StateScrollingUp,
};

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    CGPoint lastContentOffset;
    ScrollingState scrollingState;
    
    NavBarHiding *hider;
    
    NSInteger count;
}
@property (nonatomic, readonly) UINavigationBar *navBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    count = 44;

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.contentInset = (UIEdgeInsets){64, 0, 0, 0};
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:_tableView];
    
//    [_tableView.panGestureRecognizer addTarget:self action:@selector(onPanRecognized:)];
    hider = [[NavBarHiding alloc] initWithScroller:_tableView andNavBar:self.navigationController.navigationBar];
}


#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    switch (indexPath.row % 3) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"cell #%d (show)", (int)indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"cell #%d (hide)", (int)indexPath.row];
            break;
        case 2:
            cell.textLabel.text = @"insert";
        default:
            break;
    }

    cell.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s %@", __PRETTY_FUNCTION__, indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row % 3) {
        case 0:
            [hider showNavbar];
            break;
        case 1:
            [hider hideNavbar];
            break;
        case 2:
            count++;
            [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationAutomatic)];
            break;
    }
}


@end
