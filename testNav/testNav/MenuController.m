//
//  MenuController.m
//  testNav
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "MenuController.h"

@interface MenuController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *menu = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    menu.dataSource = self;
    menu.delegate = self;
    
    menu.backgroundColor = [UIColor whiteColor];
    UIEdgeInsets ei = (UIEdgeInsets){self.view.bounds.size.height - 20 * 2 /* 20 отступ снизу а еще 20? статусбар? */ - 4 * 40, 0, 0, 0};
    menu.contentInset = ei;
    [self.view addSubview:menu];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"menu item #%@", @(indexPath.row)];
    
    return cell;
}

@end
