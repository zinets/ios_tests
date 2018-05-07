//
//  PackageCell.h
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageCell : UICollectionViewCell
/// длительность пакета
@property (nonatomic, strong) NSString *duration;
/// цена пакета
@property (nonatomic, strong) NSString *price;
/// размер скидки, 1я часть (состоит из 2х разношрифтовых частей)
@property (nonatomic, strong) NSString *salePart1;
@property (nonatomic, strong) NSString *salePart2;
/// кнопка
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end
