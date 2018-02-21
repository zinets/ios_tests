//
//  TableViewCell.m
//  messageTextTest
//
//  Created by Zinets Victor on 2/21/18.
//  Copyright © 2018 Zinets Victor. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setText:(NSString *)text {
    self.label.text = text;
}

@end
