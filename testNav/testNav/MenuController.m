//
//  MenuController.m
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
    menu.bounces = NO;
    
    menu.backgroundColor = [UIColor magentaColor];
    UIEdgeInsets ei = (UIEdgeInsets){self.view.bounds.size.height - (20 + 40) /* 20 отступ снизу а еще 20? статусбар? */ - 4 * 40, 0, 0, 0};
    menu.contentInset = ei;
    [self.view addSubview:menu];
}

#pragma mark - setters

-(void)setFooterView:(UIView *)footerView {
    if (_footerView) {
        [_footerView removeFromSuperview];
    }
    // никакой анимации смены подвала не нужно; новый контроллер - выедет поверх этой заглушки и визуально все очень ок; если выезжает контроллер того же типа - то это надо предусмотреть в навконтроллере-аниматоре и задавать стартовый фрейм для появляющегося контроллера не грубо говоря 0, а уже высовывающимся - и будет опять очень норм
    _footerView = footerView;
    [self.view addSubview:_footerView];
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate menu:self didSelectItem:(MenuItem)indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    cell.textLabel.text = [NSString stringWithFormat:@"create controller #%@", @(indexPath.row % 2 + 1)];
    return cell;
}

@end
