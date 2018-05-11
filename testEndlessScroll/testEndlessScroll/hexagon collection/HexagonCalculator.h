//
//  HexagonCalculator.h
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/11/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HexagonCalculator : NSObject
/// размер области, куда вписываем соты
@property (nonatomic) CGRect bounds;
/// кол-во "столбцов"
@property (nonatomic) NSInteger cols;
/// кол-во "строк" (очевидно что цифра для справки)
@property (nonatomic, readonly) NSInteger rows;
@end
