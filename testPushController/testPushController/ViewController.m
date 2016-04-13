//
//  ViewController.m
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scroller;

@property (nonatomic, strong) UIView *fakePhotoView;
@property (nonatomic, strong) UITableView *table;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scroller];
    
    [self.scroller addSubview:self.fakePhotoView];
    [self.scroller addSubview:self.table];
}

-(UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scroller.pagingEnabled = YES;
        _scroller.contentSize = (CGSize){self.view.bounds.size.width, self.view.bounds.size.height * 2};
    }
    return _scroller;
}

-(UIView *)fakePhotoView {
    if (!_fakePhotoView) {
        _fakePhotoView = [[UILabel alloc] initWithFrame:self.view.bounds];
        borderControlWithParams(_fakePhotoView, 2, 0x7fff0000);
        ((UILabel *)_fakePhotoView).text = @"fake photo scroller here";
    }
    return _fakePhotoView;
}

-(UITableView *)table {
    if (!_table) {
        CGRect frm = self.view.bounds;
        frm.origin.y += frm.size.height;
        _table = [[UITableView alloc] initWithFrame:frm style:(UITableViewStylePlain)];
        _table.backgroundColor = [UIColor colorWithHex:0xff4040];
        
        _table.dataSource = self;
        _table.delegate = self;
    }
    return _table;
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell #%d", indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"cell addr: %p", cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
