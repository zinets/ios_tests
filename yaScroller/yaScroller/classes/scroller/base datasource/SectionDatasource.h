//
// Created by Victor Zinets on 2/6/18.
// Copyright (c) 2018 Together Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

// пока я сам не забыл, что это; база для TableSectionDatasource и CollectionSectionDatasource
// идея в том, что а) создаем таблицу, б) создаем датасорс для нее и передаем ему таблицу; в) передаем в датасорс массив из какой-то херни, которая должна отображаться в таблице (например список переписок - на большее меня не хватило пока)
// если что-то поменялось - просто передаем в датасорц новый массив - датасорц сам пересчитает элементы для удаления/вставки/обновления и сделает все, что надо, с таблицей/коллекцией
// текущее ограничение в том, что я думаю только об одной секции - мне просто не надо было больше

// Table/Collection-SectionDatasource нужны только для вычислений и обновления таблицы/коллекции; numberItems.. они возвращают 0 - следующий наследник возвращает ячейки нужного типа (напр. ChatsListDatasource)

// чтобы разница вычислялась правильно, обьекты в массиве должны уметь себя сравнивать (hash, isEqual и т.д)

@interface SectionDatasource : NSObject {
    NSArray *internalItems;

    NSMutableIndexSet *toRemove, *toInsert, *toUpdate;
}
@property (nonatomic, strong) NSArray *items;
@end
