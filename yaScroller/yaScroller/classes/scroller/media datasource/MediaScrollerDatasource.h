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
// todo убрать полноэкранность отсюда, это только тесты
@property (nonatomic) BOOL fs;
@end
