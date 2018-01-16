//
//  MiniMediaPicker.h
//  testConversations
//
//  Created by Zinets Viktor on 1/16/18.
//  Copyright © 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>

// показывает гридом фоточки из "камера рол"; или заглушку "нет фото"; или заглушку "нет доступа"
// и может повести в "большой" выбор из библиотеки

@protocol MiniMediaPickerDelegate <NSObject>
/// мини пикер хочет показать взрослый выбор медиа (с альбомами и прочим)
- (void)miniMediaPickerWantsShowFullLibrary:(id)sender;
/// выбрали картинку
- (void)miniMediaPicker:(id)sender didSelectImage:(UIImage *)image;
/// выбрали видосик
@end

@interface MiniMediaPicker : UIView
@property (nonatomic, weak) id <MiniMediaPickerDelegate> delegate;
@end
