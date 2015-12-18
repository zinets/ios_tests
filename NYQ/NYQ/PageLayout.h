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
- (void)wasTapAt:(NSIndexPath *)indexPath;
@end


@interface PageLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) BOOL editingMode;

@property (nonatomic, assign) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat scrollingSpeed;

@property (nonatomic, weak) id<PageLayoutProto>delegate;

@end
