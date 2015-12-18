//
//  BookmarksPageLayout.h
//  Browser
//
//  Created by Zinets Victor on 5/28/15.
//  Copyright (c) 2015 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ChangeLayoutDirection) {
    ChangeLayoutDirectionToLeft,
    ChangeLayoutDirectionToRight,
};

@protocol PageLayoutProto <NSObject>
@required
/// можно двигать эту ячейку (например это ячейка "добавить букмарк"
- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath;

/// можно ли двигать
- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath
           toIndexPath:(NSIndexPath *)toIndexPath;

/// ячейки поменялись местами - нужно обновить датасорс
- (void)collectionView:(UICollectionView *)collectionView
     didMoveItemAtPath:(NSIndexPath *)fromIndex
                toPath:(NSIndexPath *)toIndex;
@optional
/// начинаем/кончаем редактировать закладки
- (void)collectionViewWillStartEditing:(UICollectionView *)collectionView;
- (void)collectionViewDidEndEditing:(UICollectionView *)collectionView;
// на случай, если мы хотим анимировать смену режима сдвигом влево-вправо - раскладка ничего не знает о текущем режиме, так что ей надо подсказать, в какую сторону смещать "старые" и "новые" элементы
- (ChangeLayoutDirection)directionForChangingLayout:(UICollectionView *)collectionView;
@end


@interface PageLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) BOOL editingMode;

@property (nonatomic, assign) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat scrollingSpeed;

@property (nonatomic, weak) id<PageLayoutProto>delegate;

@end
