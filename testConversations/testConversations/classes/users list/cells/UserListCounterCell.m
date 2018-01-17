//
//  UserListCounterCell.m
//  testConversations
//
//  Created by Zinets Viktor on 1/17/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import "UserListCounterCell.h"
#import "RoundedView.h"

@interface UserListCounterCell()
@property (weak, nonatomic) IBOutlet RoundedView *roundedView;

@end

@implementation UserListCounterCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.roundedView.corners = UIRectCornerTopLeft|UIRectCornerBottomRight;
    self.roundedView.backgroundColor = [UIColor redColor];
    self.roundedView.isBorderVisible = YES;
}


@end
