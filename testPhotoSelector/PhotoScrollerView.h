//
//  LVHPhotoScrollView.h
//  Flirt
//
//  Created by Zinets Victor on 4/17/15.
//  Copyright (c) 2015 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoScrollerView;

@protocol PhotoScrollerDataSource <NSObject>
@required
- (NSInteger)numberOfPhotos;
- (UIView *)scroller:(PhotoScrollerView *)scroller viewForIndex:(NSInteger)index;
@optional
- (CGFloat)spaceBetweenViews:(PhotoScrollerView *)sender;
- (CGSize)scroller:(PhotoScrollerView *)scroller sizeForViewWithIndex:(NSInteger)index;
@end

@protocol PhotoScrollerDelegate <UIScrollViewDelegate>
@optional
- (void)scroller:(PhotoScrollerView *)scroller photoIndexChanged:(NSInteger)index;
//текущий индекс, перед началом скролла
- (void)photoIndexWillChange:(NSInteger)index;
- (void)scroller:(PhotoScrollerView *)scroller didSelectPhoto:(NSInteger)index;
/// кривость! прибито гвоздями!! оттягиваем влево..
/// мы "перетянули" скроллер влево бОльше, чем на заданное расстояние
/// что-то после этого сделаем - например покажем список фото..
- (void)scrollerWasOverscrolled:(PhotoScrollerView *)scroller;
/// вью в скроллере оттягивается вниз на 0 - 1 от максимума
- (void)scroller:(PhotoScrollerView *)scroller wasPulledDownBy:(CGFloat)pullOffset;
/// был pull-down-to-exit
- (void)scrollerDetectedPullDown:(PhotoScrollerView *)scroller;
@end

/// очередная имплементация листалки фото
@interface PhotoScrollerView : UIScrollView {
    @protected
    NSMutableDictionary * visiblePhotos;
}
@property (nonatomic, weak) id <PhotoScrollerDataSource> dataSource;
@property (nonatomic, weak) id <PhotoScrollerDelegate> photoScrollerDelegate;

@property (nonatomic, strong) UITapGestureRecognizer * tapRecognizer;
/// если нечего вообще показывать, то в reload покажеться это вью
@property (nonatomic, strong) UIView * placeholder;

@property (nonatomic, assign) NSInteger currentPhotoIndex;

@property (nonatomic, assign) BOOL verticalScrolling;
/// значение на которое надо оттянуть вниз вью в скроллере, чтобы сработало событие "pull-down-to-exit"
@property (nonatomic, assign) CGFloat pullDownLimit;

- (void)reloadPhotos;
/// обновить фото, промотать скроллер в начало
- (void)reset;
- (UIView *)dequeueView;
- (UIView *)currentView;

@end
