//
//  UrlImageView2.h
//  MUIControls
//
//  Created by Zinets Victor on 10/1/15.
//  Copyright © 2015 iCupid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UrlImageView2 : UIImageView
/// картинка загрузилась и готова "установиться" во вью
@property (nonatomic, copy) UIImage * (^onImageLoaded)(UIImage * img);
/// картинка "установилась" на место
@property (nonatomic, copy) void(^onLoadCompleted)(CGSize imageSize);
/// неведомая ошибка 
@property (nonatomic, copy) void(^onLoadError)();

/// заглушка на время, пока image == nil; в сеттере заглушка получит фрейм контрола
@property (nonatomic, strong) UIView *placeholderView;
/// заглушка на время загрузки урла; в сеттере заглушка поместится в центр контрола
@property (nonatomic, strong) UIView *loadingView;
/// нахлопка, которая будет нахлоплена (если она существует) после загрузки
@property (nonatomic, strong) UIView *overlayView;

/// если передать ненулевой size, то, после загрузки оригинала, картинка будет отресайжена в бекграунде (методом fillInSize) и отображена через setImage:
@property (nonatomic, assign) CGSize resizeImageToSize;
/// по умолчанию - NO, если YES - то отресайженые картинки будут кешироватся
@property (nonatomic, assign) BOOL shouldCacheResizedImage;

/// разрешить добавить анимацию в момент собственно загрузки фото (YES by default)
@property (nonatomic, assign) BOOL allowLoadingAnimation;
/// время анимации (default = 0, хотя это не значит что анимации нет, така вот фигня)
@property (nonatomic, assign) CGFloat loadingAnimationDuration;

/// очищать изображение перед загрузкой нового
@property (nonatomic, assign) BOOL hasToClearImage;

/// загрузить картинку из урла; можно загрузить nil == "обнулить" картинку
-(void)loadImageFromUrl:(NSString *)url;
/// загрузить картинку из урла, forceLoad - если нужна принудительная загрузка, даже если урлы одинаковые
-(void)loadImageFromUrl:(NSString *)url forceLoad:(BOOL)forceLoad;

/// загрузить в кеш пачку урлов
- (void)preloadImages:(NSArray <NSString *>*)urlList;

@end
