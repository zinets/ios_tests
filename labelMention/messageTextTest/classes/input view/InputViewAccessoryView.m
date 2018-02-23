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

// я считаю, что это все равно очень кривое решение - изменение высоты accessotyView таким способом; но ничего лучше не получилось
// собственно использование vvv
-(CGSize)intrinsicContentSize {
    CGSize sz = self.bounds.size;
    CGFloat const cellHeight = CELL_HEIGHT;
    NSInteger rowsCount = MIN(4, _dataSource.count);
    sz.height = rowsCount * cellHeight;
    
    return sz;
}
// ^^^ как раз очень правильно; где-то "там" мы говорим [... reloadInputViews] и тадам! система пересчитывает размер контента, НО - хз что с этим делать дальше.. если бы это было "обычное" вью, обставленное со всех сторон контсрантами, то после изменения intrinsicContentSize все вокруг пересчиталось бы; но для случая с accessoryInputView это не работает (или я тупой чтобы понять как должно); разные "хаки" типа "взять у списка констрантов этого вью первый и менять его значение, надеясь, что это будет "скрытый" констрант изменения высоты, который использует аппле" больше похоже на теорию заговора, чем на код

-(void)layoutSubviews {
    CGRect frm = self.frame;
    frm.size = self.intrinsicContentSize;
    CGFloat dy = self.frame.size.height - frm.size.height;
    frm.origin.y += dy;
    
    self.frame = frm;
    
    [super layoutSubviews];
}

// так что такой вариант: я не сомневаюсь, что рано или поздно что-то пойдет по пи3де и этот контрол зависнет или сьедет куда-то хз куда не надо :(

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

