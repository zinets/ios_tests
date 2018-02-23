//
//  InputViewAccessoryView.m
//  messageTextTest
//
//  Created by Zinets Victor on 2/22/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "InputViewAccessoryView.h"
#import "InputViewAccessoryCell.h"

@implementation MentionedUser

+(instancetype)userWithName:(NSString *)screenname avatar:(NSString *)avatar {
    MentionedUser *res = [[MentionedUser alloc] initWithName:screenname avatar:avatar];
    return res;
}

-(instancetype)initWithName:(NSString *)screenname avatar:(NSString *)avatar {
    if (self = [super init]) {
        _screenname = screenname;
        _avatarUrl = avatar;
    }
    return self;
}

@end

@interface InputViewAccessoryView() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation InputViewAccessoryView

#define CELL_HEIGHT 66.

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%s",__PRETTY_FUNCTION__);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"%s",__PRETTY_FUNCTION__);
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

-(CGSize)intrinsicContentSize {
    CGSize sz = self.bounds.size;
    CGFloat const cellHeight = CELL_HEIGHT;
    NSInteger rowsCount = MIN(4, _dataSource.count);
    sz.height = rowsCount * cellHeight;
    
    return sz;
}

-(void)layoutSubviews {
    CGRect frm = self.frame;
    frm.size = self.intrinsicContentSize;
    CGFloat dy = self.frame.size.height - frm.size.height;
    frm.origin.y += dy;
    
    self.frame = frm;
    
    [super layoutSubviews];
}

#pragma mark - table

-(void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InputViewAccessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputViewAccessoryCell"];
    MentionedUser *userInfo = self.dataSource[indexPath.row];
    cell.screenName = userInfo.screenname;
    cell.avatarUrl = userInfo.avatarUrl;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(accessoryView:didSelectItemAtIndex:)]) {
        [self.delegate accessoryView:self didSelectItemAtIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

