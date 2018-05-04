//
//  PackagesContainerLayout.h
//  pagerWithAnimations
//
//  Created by Victor Zinets on 5/3/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackagesContainerLayout : UICollectionViewLayout
/// размер маленькой ячейки; адоптируецца для разных экранов, ждет значение из диза для 4.7"
@property (nonatomic) CGSize itemSize;
/// размер БОЛЬШОЙ ячейки; адоптируецца для разных экранов, ждет значение из диза для 4.7"
@property (nonatomic) CGSize selectedItemSize;
/// расстояние между ячейками - не одоптируеца потому что пошло оно все нах
@property (nonatomic) CGFloat minimumInterItemSpacing;
@end
