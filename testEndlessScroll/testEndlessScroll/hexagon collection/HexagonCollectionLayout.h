//
// Created by Victor Zinets on 5/11/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NSAutocalculatedCount -1
@interface HexagonCollectionLayout : UICollectionViewLayout
/// default value is NSAutocalculatedCount 
@property (nonatomic) NSInteger columnsCount;
/// при определенном размере коллекции в нее можно всунуть ограниченное кол-во элементов
-(NSInteger)capacityOfLayoutMaxCount:(NSInteger)maxCount;
@end
