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

@interface MediaScrollerView : UIView
/// выравнивать ли ячейки
@property (nonatomic) BOOL paginating;
/// ограничить прокрутку одним элементов за раз
@property (nonatomic) BOOL oneElementPaginating;
/// бесконечная прокрутка
@property (nonatomic) BOOL endlessScrolling;
/// направление прокрутки
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

/// tap to scroll - тап по краю картинки (скажем, на расстоянии ХХ от края) вызывает прокрутку
@property (nonatomic) BOOL tapToScroll;

/// datasource
@property (nonatomic) NSArray *items;

/// delegate
@property (nonatomic, weak) id <MediaScrollerViewDelegate> delegate;
@end
