//
// Created by Victor Zinets on 2/6/18.
// Copyright (c) 2018 Together Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionDatasource.h"

// абстрактный класс - источник для коллекции; умеет считать дифы, но конкретное наполнение коллекции его не касается
@interface CollectionSectionDatasource : SectionDatasource <UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@end
