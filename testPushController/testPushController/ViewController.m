//
//  ViewController.m
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "ViewController.h"
#import "PushAnimator.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIScrollView *scroller;

@property (nonatomic, strong) UIView *fakePhotoView;
@property (nonatomic, strong) UITableView *table;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.scroller];
    
    [self.scroller addSubview:self.fakePhotoView];
    [self.scroller addSubview:self.table];
}

-(UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scroller.pagingEnabled = YES;
        _scroller.contentSize = (CGSize){self.view.bounds.size.width, self.view.bounds.size.height * 2};
        _scroller.backgroundColor = [UIColor whiteColor];
        _scroller.delegate = self;
    }
    return _scroller;
}

-(UIView *)fakePhotoView {
    if (!_fakePhotoView) {
        CGRect frm = self.view.bounds;
        frm.size.height -= 64;
        frm.origin.y = 64;
        _fakePhotoView = [[UILabel alloc] initWithFrame:frm];
        _fakePhotoView.backgroundColor = [UIColor clearColor];
        borderControlWithParams(_fakePhotoView, 2, 0x7fff0000);
        ((UILabel *)_fakePhotoView).text = @"fake photo scroller here";
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"t1"]];
        frm = iv.frame;
        frm.origin = (CGPoint){20, 70};
        iv.frame = frm;
        [_fakePhotoView addSubview:iv];
        
        iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"t2"]];
        frm = iv.frame;
        frm.origin = (CGPoint){120, 270};
        iv.frame = frm;
        [_fakePhotoView addSubview:iv];
        
        iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"t3"]];
        frm = iv.frame;
        frm.origin = (CGPoint){50, 400};
        iv.frame = frm;
        [_fakePhotoView addSubview:iv];
    }
    return _fakePhotoView;
}

-(UITableView *)table {
    if (!_table) {
        CGRect frm = self.view.bounds;
        frm.origin.y += frm.size.height + 64;
        frm.size.height -= 64;
        _table = [[UITableView alloc] initWithFrame:frm style:(UITableViewStylePlain)];
        _table.backgroundColor = [UIColor clearColor];//colorWithHex:0xff4040];
        
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
    cell.textLabel.text = [NSString stringWithFormat:@"Cell #%d", indexPath.row % 3];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"cell addr: %p", cell];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UIViewController *ctrl = nil;
    switch (indexPath.row % 3) {
        case 0:
            ctrl = [Controller0 new];
            break;
        case 1:
            ctrl = [Controller1 new];
            break;
        case 2:
            ctrl = [Controller2 new];
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - scroller

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _scroller) {
        CGRect frm = self.fakePhotoView.frame;
        frm.origin = (CGPoint){0, _scroller.contentOffset.y + _scroller.contentInset.top};
        self.fakePhotoView.frame = frm;
        CGFloat alpha = 1 - scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.bounds.size.height);
        scrollView.backgroundColor = [UIColor colorWithHex:0xffffff alpha:alpha];
    }
}



@end
