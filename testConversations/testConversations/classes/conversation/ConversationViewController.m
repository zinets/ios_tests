//
//  TableViewController.m
//  testConversations
//
//  Created by Zinets Viktor on 1/5/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationDataSource.h"
#import "ConversationCell.h"
#import "DailyMessages.h"

#import "UIViewController+Keyboard.h"

@interface ConversationViewController () <UITableViewDataSource, UITableViewDelegate, ConversationDataSourceDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ConversationDataSource *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewHeight;
@end

@implementation ConversationViewController {
    NSArray *tempData;
    NSInteger tempIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [ConversationDataSource new];
    self.dataSource.delegate = self;
    self.dataSource.isConversationPublic = YES;
    
    [self.tableView registerClass:[ConversationHeader class] forHeaderFooterViewReuseIdentifier:@"ConversationHeaderId"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerKeyboard];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unregisterKeyboard];
}

#pragma mark temp

-(void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container {
    CGSize sz = ((UIViewController *)container).preferredContentSize;
    self.inputViewHeight.constant = sz.height;
}

- (IBAction)onButtonTap:(id)sender {

}

- (IBAction)onResign:(id)sender {
}

- (NSDate *)dateFromString:(NSString *)strDate {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    return [dateFormat dateFromString:strDate];
}

- (NSArray *)tempDataSet {
    if (!tempData) {
        NSString *ownScreenname = @"Sierra";
        NSString *userScreenname = @"anime girl";
        NSMutableArray <MessageModel *> *data = [NSMutableArray array];
        
        MessageModel *m = [MessageModel new]; {
            m.message = @"1 Wow.";
            m.messageDate = [self dateFromString:@"25.12.2017 13:34"];
            m.ownMessage = NO;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"xmas is here!!!";
            m.messageDate = [self dateFromString:@"25.12.2017 23:54"];
            m.ownMessage = NO;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"2 So what is going on?";
            m.messageDate = [self dateFromString:@"31.12.2017 13:34"];
            m.ownMessage = NO;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
            //        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
        }
        [data addObject:m];
        
        // lost message from last xmas
        {
            m = [MessageModel new]; {
                m.message = @"lost message from earlier date";
                m.messageDate = [self dateFromString:@"25.12.2017 23:34"];
                m.ownMessage = NO;
                m.screenName = m.ownMessage ? ownScreenname : userScreenname;
                m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
            }
            [data addObject:m];
        }
        
        m = [MessageModel new]; {
            m.message = @"3 We had a meth addict in here this morning who @Max was biologically younger.";
            m.messageDate = [self dateFromString:@"31.12.2017 19:34"];
            m.ownMessage = YES;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
            //        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
        }
        
        [data addObject:m];
        m = [MessageModel new]; {
            m.message = @"4";
            m.messageDate = [self dateFromString:@"07.01.2018 13:34"];
            m.ownMessage = YES;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
            //        m.avatarUrl = @"http://icons.iconarchive.com/icons/iloveicons.ru/browser-girl/256/browser-girl-chrome-icon.png";
            m.photoUrl = @"img2.jpg";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"own message 1";
            m.messageDate = [self dateFromString:@"08.01.2018 10:00"];
            m.ownMessage = YES;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"own message 2";
            m.messageDate = [self dateFromString:@"08.01.2018 12:10"];
            m.ownMessage = YES;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"own message 3";
            m.messageDate = [self dateFromString:@"08.01.2018 14:00"];
            m.ownMessage = YES;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"user message 1";
            m.messageDate = [self dateFromString:@"08.01.2018 14:14"];
            m.ownMessage = NO;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.messageDate = [self dateFromString:@"08.01.2018 14:14"];
            m.ownMessage = NO;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
            m.photoUrl = @"img1.jpg";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"user message 2";
            m.messageDate = [self dateFromString:@"08.01.2018 14:25"];
            m.ownMessage = NO;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"own message 4";
            m.messageDate = [self dateFromString:@"08.01.2018 15:00"];
            m.ownMessage = YES;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"own message 5 (last)";
            m.messageDate = [self dateFromString:@"08.01.2018 15:05"];
            m.ownMessage = YES;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"user message 3 (last)";
            m.messageDate = [self dateFromString:@"08.01.2018 19:25"];
            m.ownMessage = NO;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
        }
        [data addObject:m];
        
        m = [MessageModel new]; {
            m.message = @"7 Kidney function, liver function.";
            m.messageDate = [self dateFromString:@"09.01.2018 13:34"];
            m.ownMessage = NO;
            m.screenName = m.ownMessage ? ownScreenname : userScreenname;
            m.avatarUrl = m.ownMessage ? @"avatar1" : @"avatar2";
            //        m.avatarUrl = @"https://0.gravatar.com/avatar/057053cdc01651a9e7f038b3e9b2c60c?s=256&d=identicon&r=G";
        }
        [data addObject:m];
        
        //        NSDate *truncatedDate, *currentDate = nil;
        //        NSMutableArray *messages;
        //
        //        NSMutableArray *tempArrayOfMessages = [NSMutableArray array];
        //        for (MessageModel *messageModel in
        //             [data sortedArrayUsingComparator:^NSComparisonResult(MessageModel *obj1, MessageModel *obj2) {
        //            return [obj1.messageDate compare:obj2.messageDate];
        //        }]) {
        //            truncatedDate = [self truncateDateTime:messageModel.messageDate];
        //            if (![truncatedDate isEqualToDate:currentDate]) {
        //                currentDate = truncatedDate;
        //                messages = [NSMutableArray array];
        //                [tempArrayOfMessages addObject:messages];
        //            }
        //
        //            [messages addObject:messageModel];
        //        }
        
        tempData = [data copy];
    }
    return tempData;
}

- (IBAction)onTap:(id)sender {
    [self.dataSource addMessages:@[[self tempDataSet][tempIndex]]];
//    [self.dataSource addMessages:[self tempDataSet]];
    tempIndex++;
//    [self.tableView reloadData];
}

- (IBAction)onClear:(id)sender {
    [self.dataSource removeAllMessages];
    [self.tableView reloadData];
    
    tempIndex = 0;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark dates

- (NSDate *)truncateDateTime:(NSDate *)dateTime {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit flags = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *components = [cal components:flags fromDate:dateTime];
    
    return [cal dateFromComponents:components];
}

#pragma mark datasource delegation

- (void)sender:(id)sender didAddSections:(NSIndexSet *)sections {
    [self.tableView insertSections:sections withRowAnimation:(UITableViewRowAnimationFade)];
}

-(void)sender:(id)sender didUpdateSections:(NSIndexSet *)sections {
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        ConversationHeader *hdr = (ConversationHeader *)[self.tableView headerViewForSection:idx];
        hdr.headerText = [NSString stringWithFormat:@"%@", [self truncateDateTime:[self.dataSource messagesOfSectionAtIndex:idx].date]];
    }];
    
//    [self.tableView reloadSections:sections withRowAnimation:(UITableViewRowAnimationFade)];
}

- (void)sender:(id)sender didAddItems:(NSArray <NSIndexPath *> *)indexes {    
    [self.tableView insertRowsAtIndexPaths:indexes withRowAnimation:(UITableViewRowAnimationAutomatic)];
}

- (void)sender:(id)sender didUpdateItems:(NSArray <NSIndexPath *> *)indexes {
    [indexes enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        ConversationCellConfig *config = [[self.dataSource messagesOfSectionAtIndex:indexPath.section] configOfCellAtIndex:indexPath.row];
        ConversationCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell applyConfig:config];
    }];
//    [self.tableView reloadRowsAtIndexPaths:indexes withRowAnimation:(UITableViewRowAnimationFade)];
}

@end
