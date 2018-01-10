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
#import "DailyMessages.h"

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DataSource *dataSource;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [DataSource new];
    [self.tableView registerClass:[ConversationHeader class] forHeaderFooterViewReuseIdentifier:@"ConversationHeaderId"];
}

#pragma mark table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataSource messagesOfSectionAtIndex:section] numberOfMessages];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationCellConfig *config = [[self.dataSource messagesOfSectionAtIndex:indexPath.section] configOfCellAtIndex:indexPath.row];
    NSString *cellId = @"ConversationMessageCellId";
    switch (config.messageType) {
        case MessageTypePhoto:
            cellId = @"ConversationPhotoCellId";
            break;
        case MessageTypeVideo:
            cellId = @"ConversationVideoCellId";
            break;
        default:
            break;
    }
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell applyConfig:config];

    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ConversationHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ConversationHeaderId"];
    
    header.headerText = [NSString stringWithFormat:@"%@", [self truncateDateTime:[self.dataSource messagesOfSectionAtIndex:section].date]];

    return header;
}

#pragma mark dates

- (NSDate *)truncateDateTime:(NSDate *)dateTime {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit flags = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *components = [cal components:flags fromDate:dateTime];
    
    return [cal dateFromComponents:components];
}

@end
