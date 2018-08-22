//
//  MediaScrollerView.h
//  yaScroller
//
//  Created by Victor Zinets on 6/5/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MediaScrollerViewDelegate <NSObject>
- (void)mediaScroller:(id)sender didSelectItem:(id)itemFromDataSource;
@end


/*  класс для скрола всяких картинок; требует класс-датасорс (MediaScrollerDatasource) для прозрачной вставки/удаления элементов
    данные для показа передаются в items и внутри передается в внутренний датасорс
    регистрация ячейки производится в MediaScrollerDatasource; вообще тот класс должен понимать, что делать с данными, которые ему передаются через items - 
*/

@interface MediaScrollerView : UIView
/// выравнивать ли ячейки
@property (nonatomic) BOOL paginating;
/// ограничить прокрутку одним элементов за раз
@property (nonatomic) BOOL oneElementPaginating;
/// бесконечная прокрутка - не использовать, работает криво
@property (nonatomic) BOOL endlessScrolling;
/// направление прокрутки
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

/// tap to scroll - тап по краю картинки (скажем, на расстоянии ХХ от края) вызывает прокрутку
@property (nonatomic) BOOL tapToScroll;

/// datasource
@property (nonatomic) NSArray *items;

/// delegate
@property (nonatomic, weak) id <MediaScrollerViewDelegate> delegate;

// подержка анимированного изменения размеров
@property (nonatomic, readonly) UIImage *image;
- (void)updateLayout;
@end
