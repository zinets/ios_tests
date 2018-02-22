//
//  InputViewAccessoryView.m
//  messageTextTest
//
//  Created by Zinets Victor on 2/22/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "InputViewAccessoryView.h"

@interface InputViewAccessoryView() <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InputViewAccessoryView

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputViewAccessoryCell"];
    
    return cell;
}

@end

