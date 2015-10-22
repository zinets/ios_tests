//
//  KVOViewController.m
//  testKvoTable
//
//  Created by Zinetz Victor on 01.07.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "KVOViewController.h"

@interface KVOViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView * _table;
    NSMutableArray * _dataSource;
    
    NSMutableString * test;
}
@end

@implementation KVOViewController

#define buttons_count 6

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    _dataSource = [NSMutableArray arrayWithCapacity:100];
    [_dataSource addObjectsFromArray:@[@"111111", @"222222", @"33333", @"4444444", @"5555", @"6666",
                                      @"3r235r", @"rewgwerv", @"34g45g", @"3453b5", @"werbwrb",
                                      @"34t234t", @"3r234v", @"erv23r", @"13f434f", @"134f314", @"34f34f"]];
    CGRect frame = self.view.bounds;
    frame.origin.y = 100;
    frame.size.height -= 100;
    _table = [[UITableView alloc] initWithFrame:frame style:(UITableViewStylePlain)];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
    
    frame.origin.x = 0; frame.origin.y = 0;
    frame.size.width = frame.size.width / buttons_count; frame.size.height = 100;
    UIButton * btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:@"add" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(addItems:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    frame.origin.x = frame.size.width;
    btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:@"del" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(deleteItems:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];

    frame.origin.x += frame.size.width;
    btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:@"ins" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(insItems:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];

    frame.origin.x += frame.size.width;
    btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:@"batch" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(batchOp:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    frame.origin.x += frame.size.width;
    btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:@"new items" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(newItems:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];

    frame.origin.x += frame.size.width;
    btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitle:@"change" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(changeItems:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
    
    test = [NSMutableString stringWithString:@"initial string"];
    [self.data addObject:test];
    // kvo
    [self addObserver:self forKeyPath:@"_dataSource"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
    [self addObserver:self forKeyPath:@"_dataSource."
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

-(void)batchOp:(id)sender {
    NSInteger count = self.data.count;
    if (count > 5) {
        NSString * newText = [NSString stringWithFormat:@"insert new item %d", self.data.count];
        [self.data insertObject:newText atIndex:0];
        [self.data removeLastObject];
        newText = [NSString stringWithFormat:@"add new item %d", self.data.count];
        [self.data addObject:newText];
        [self.data removeObjectAtIndex:3];
        [self.data addObjectsFromArray:@[@"add1", @"add2", @"add3", @"add4", @"add5"]];
    }
}

-(void)insItems:(id)sender {
    NSInteger count = self.data.count;
    NSInteger rowToIns = count ? random() % self.data.count : 0;
    NSString * newText = [NSString stringWithFormat:@"new item %d", self.data.count];
    [self.data insertObject:newText atIndex:rowToIns];
}

-(void)addItems:(id)sender {
    NSString * newText = [NSString stringWithFormat:@"new item %d", self.data.count];
    [self.data addObject:newText];
}

-(void)deleteItems:(id)sender {
    NSInteger count = self.data.count;
    if (count) {
        NSInteger rowToDelete = random() % count;
        [self.data removeObjectAtIndex:rowToDelete];
    }
}

-(void)newItems:(id)sender {
    self.data = @[@"qweqwe", @"asdasd", @"zxczc", @"teertyr", @"eryery", @"rtyrt", @"ghnghn", @"xbxfb", @"ergerg", @"tyjtyj", @"vnfyrty"];
}

-(void)changeItems:(id)sender {
//    self.data[0] = @"new data";
    [test appendString:@"addition"];
}

#pragma mark - table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
    }
    NSString * cellTitle = _dataSource[indexPath.row];
    cell.textLabel.text = cellTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"item #%d", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - kvo

-(void)setData:(NSMutableArray *)data {
    NSMutableArray * arr = [self mutableArrayValueForKey:@"_dataSource"];
    [arr removeAllObjects];
    [arr addObjectsFromArray:data];
}

-(NSMutableArray *)data {
    return [self mutableArrayValueForKey:@"_dataSource"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    NSLog(@"keyPath:%@ object:%@ change:%@", keyPath, object, change);
    
    NSIndexSet * indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
    if (indexes) {
        NSMutableArray * indexPathArray = [NSMutableArray array];
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [indexPathArray addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
        }];
        
        NSNumber *kind = [change objectForKey:NSKeyValueChangeKindKey];
        if ([kind integerValue] == NSKeyValueChangeInsertion) {
            [_table insertRowsAtIndexPaths:indexPathArray
                          withRowAnimation:UITableViewRowAnimationRight];
            [_table scrollToRowAtIndexPath:indexPathArray[0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
        } else if ([kind integerValue] == NSKeyValueChangeRemoval) {
            [_table deleteRowsAtIndexPaths:indexPathArray
                          withRowAnimation:UITableViewRowAnimationLeft];
        } else if ([kind integerValue] == NSKeyValueChangeSetting) {
            NSLog(@"%s", __PRETTY_FUNCTION__);
        } else if ([kind integerValue] == NSKeyValueChangeReplacement) {
            [_table reloadRowsAtIndexPaths:indexPathArray withRowAnimation:(UITableViewRowAnimationAutomatic)];
        }
    }
}

@end
