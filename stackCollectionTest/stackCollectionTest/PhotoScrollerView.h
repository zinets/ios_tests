//
//  LVHPhotoScrollView.h
//  Flirt
//
//  Created by Zinets Victor on 4/17/15.
//  Copyright (c) 2015 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoScrollerView;
@protocol PhotoScrollerViewProto <NSObject>
@required
- (NSInteger)numberOfPhotos;
- (UIView *)scroller:(PhotoScrollerView *)scroller viewForIndex:(NSInteger)index;
@optional
- (CGFloat)spaceBetweenViews:(PhotoScrollerView *)sender;
- (CGSize)scroller:(PhotoScrollerView *)scroller sizeForViewWithIndex:(NSInteger)index;

- (void)photoIndexChanged:(NSInteger)index;
//текущий индекс, перед началом скролла
- (void)photoIndexWillChange:(NSInteger)index;
- (void)scroller:(PhotoScrollerView *)scroller didSelectPhoto:(NSInteger)index;
/// кривость! прибито гвоздями!! оттягиваем влево..
/// мы "перетянули" скроллер влево бОльше, чем на заданное расстояние
/// что-то после этого сделаем - например покажем список фото..
- (void)scrollerWasOverscrolled:(PhotoScrollerView *)scroller;
@end

/// очередная имплементация листалки фото
@interface PhotoScrollerView : UIScrollView
@property (nonatomic, weak) id <PhotoScrollerViewProto> dataSource;
@property (nonatomic, strong) UITapGestureRecognizer * tapRecognizer;
/// если нечего вообще показывать, то в reload покажеться это вью
@property (nonatomic, strong) UIView * placeholder;
@property (nonatomic, assign) NSInteger currentPhotoIndex;
@property (nonatomic, assign) BOOL verticalScrolling;

- (void)reloadPhotos;
/// обновить фото, промотать скроллер в начало
- (void)reset;
- (UIView *)dequeueView;
@end
