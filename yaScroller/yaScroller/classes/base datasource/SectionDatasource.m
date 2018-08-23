//
// Created by Victor Zinets on 2/6/18.
// Copyright (c) 2018 Together Networks. All rights reserved.
//

#import "SectionDatasource.h"

#define min(x1, x2, x3) MIN(x1, MIN(x2, x3));

@implementation SectionDatasource {

}

- (void)setItems:(NSArray *)items {
    // здесь нужно, чтобы при присваивании не присвоился просто указатель; нужен отдельный массив, с которым можно сравнить и получить diff с присваиваемым; а пос. новый массив будет хранить ссылки на те эе элементы, то перерасход памяти чисто символический
    [self calculateChangesFrom:internalItems to:items];
    internalItems = [items copy];
}

- (NSArray *)items {
    return internalItems;
}

- (BOOL)objectsEqual:(id <NSObject>)obj1 :(id <NSObject>)obj2 {
    BOOL res = [obj1 isEqual:obj2];
    return res;
}

- (void)calculateChangesFrom:(NSArray *)fromArray to:(NSArray *)toArray {
    toRemove = [NSMutableIndexSet indexSet];
    toInsert = [NSMutableIndexSet indexSet];
    toUpdate = [NSMutableIndexSet indexSet];

    if ((fromArray.count == 0 && toArray.count == 0) || // ничего делать не нужно
            [fromArray isEqualToArray:toArray]) {
        return;
    } else if (fromArray.count == 0 && toArray.count != 0) { // вставить все
        [toArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self->toInsert addIndex:idx];
        }];
        return;
    } else if (fromArray.count != 0 && toArray.count == 0) { // грохнуть все
        [fromArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self->toRemove addIndex:idx];
        }];
        return;
    }

    NSInteger temp[fromArray.count + 1][toArray.count + 1];
    for (NSUInteger x = 0; x < toArray.count + 1; x++) {
        temp[0][x] = x;
    }
    for (NSUInteger x = 0; x < fromArray.count + 1; x++) {
        temp[x][0] = x;
    }

    for (NSUInteger i = 1; i <= fromArray.count; i++) {
        for (NSUInteger j = 1; j <= toArray.count; j++) {
            if ([self objectsEqual:fromArray[i - 1]:toArray[j - 1]]) {
                temp[i][j] = temp[i - 1][j - 1];
            } else {
                temp[i][j] = 1 + min(temp[i - 1][j - 1], temp[i - 1][j], temp[i][j - 1]);
            }
        }
    }

//    for (NSUInteger i = 0; i <= fromArray.count; i++) {
//        NSString *string = @"";
//        for (NSUInteger j = 0; j <= toArray.count; j++) {
//            string = [string stringByAppendingFormat:@"%@ ", @(temp[i][j])];
//        }
//        NSLog(string);
//    }

    NSInteger i = fromArray.count;
    NSInteger j = toArray.count;
    while (1) {
        if (i == 0 && j == 0) {
            break;
        }
        if (i > 0 && j > 0 && [fromArray[i - 1] isEqual:toArray[j - 1]]) {
            i = i - 1;
            j = j - 1;
        } else if (i > 0 && j > 0 && temp[i][j] == temp[i - 1][j - 1] + 1){
//            NSLog(@"replace %@ with %@", fromArray[i - 1], toArray[j - 1]);
            [toUpdate addIndex:i - 1];
            i = i - 1;
            j = j - 1;
        } else if (i > 0 && temp[i][j] == temp[i - 1][j] + 1) {
//            NSLog(@"Delete %@ @ index %@", fromArray[i - 1], @(i - 1));
            [toRemove addIndex:i - 1];
            i = i - 1;
        } else if (j > 0 && temp[i][j] == temp[i][j - 1] + 1){
//            NSLog(@"Insert %@ @ index %@", toArray[j - 1], @(j - 1));
            [toInsert addIndex:j - 1];
            j = j - 1;
        } else {
            NSLog(@"WTF?");
        }
    }
}

@end
