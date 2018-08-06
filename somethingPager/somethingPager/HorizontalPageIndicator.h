//
//  FlirtPageIndicator.h
//  Flirt
//
//  Created by Zinetz Victor on 09.09.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalPageIndicator : UIView
@property (nonatomic, assign) NSInteger  numberOfPages;
@property (nonatomic, assign) NSInteger  currentPage;

/// можно и даже лучше использовать вместо имеджей
@property (nonatomic, strong) UIView *inactiveMarkView;
@property (nonatomic, strong) UIView *selectedMarkView;

@property (nonatomic, strong) UIImage * inactiveMark;
@property (nonatomic, strong) UIImage * selectedMark;

/// теперь горизонтальный индикатор может быть вертикальным
@property (nonatomic, assign) BOOL vertical;
/// по-умолчанию выравнивание марков делается по центру, если edgeAlignment = YES, то по левому верхнему углу
@property (nonatomic, assign) BOOL edgeAlignment;
/// расстояние между "тиками"
@property (nonatomic) CGFloat spacing;

/// в ффи надо отображать замочек вместо последнего элемента списка - для этого затычка
@property (nonatomic, strong) UIImage *lastInactiveMark;
@property (nonatomic, strong) UIImage *lastSelectedMark;

- (UIImage *)imageFromView:(UIView *)view;
@end
