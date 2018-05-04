//
//  PackageCell.m
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "PackageCell.h"

@interface PackageCell()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation PackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // todo: добавить в атрибуты поле "прогрес"?? внутри ячейки никак не вычислить прозрачности/размеры/видимость, зависящие от размеров - т.к. размеры вообще разные на разных экранах
    CGFloat a = 1 - 0.57 * ((244 - self.bounds.size.width) / 244);
//    NSLog(@">>>> %f", a);
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:a];
    
    a = self.bounds.size.width / 244.;
    
    self.button.transform = CGAffineTransformMakeScale(a, a);
}

@end
