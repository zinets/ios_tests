//
//  TableViewController.m
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "TableViewController.h"
#import "DataSource.h"
#import "ConversationCell.h"

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DataSource *dataSource;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [DataSource new];
}

#pragma mark table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfMessages];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCellId"];
    MessageModel *m = [self.dataSource messageAtIndex:indexPath.row];
    cell.message = m.message;
    NSDateFormatter *frm = [NSDateFormatter new];
    frm.dateStyle = NSDateFormatterShortStyle;
    cell.messageDate = [frm stringFromDate:m.messageDate];
    cell.isOwnMessage = m.ownMessage;
    cell.cellType = ConversationCellTypeLast;

    return cell;
}

@end
