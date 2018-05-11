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
/// получившийся из исходных (фрейм для размещения, кол-во столбцов) размер элемента
@property (nonatomic, readonly) CGSize elementSize;
/// массив центров ячеек
@property (nonatomic, readonly) NSArray <NSValue /* CGPoint */ *> *centers;
/// кол-во элементов
@property (nonatomic, readonly) NSInteger numberOfItems;

/// красивое с точки зрения дизайна кол-во столбцов для указанного кол-ва элементов
- (NSInteger)proposedNumberOfColumnsFor:(NSInteger)numberOfElements;
@end
