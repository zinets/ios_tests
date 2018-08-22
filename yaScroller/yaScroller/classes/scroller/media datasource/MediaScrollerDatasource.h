//
//  MediaScrollerDatasource.h
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "CollectionSectionDatasource.h"

// конкретный наследник dataSource знает а) (?) класс данных, которыми он владеет и б) класс ячейки, которая показывает данные
// или можно ограничится только ячейкой? а если разные типы в данных, как определять какую ячейку использовать?
@interface MediaScrollerDatasource : CollectionSectionDatasource

// методы для бесконечной прокрутки
- (void)shiftDataLeft;
- (void)shiftDataRight;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic) UIViewContentMode contentMode;
@end
