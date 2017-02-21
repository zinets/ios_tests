//
//  ImageViewControl.h
//

#import <UIKit/UIKit.h>

@protocol ControlPullDownProtocol <NSObject>
@required
/// делегат должен задать размер "оттяжки" для срабатывания
@property (nonatomic, assign) CGFloat pullDownLimit;
/// в этом методе можно сделать зачистку после анимации "выход из просмотра с зумом через пул-довн"
- (void)controlReachedPullDownLimit:(id)sender;
@optional
/// в этом методе можно отображать прогресс оттяжки (или постепенно убирать какие-то вспомогательные контролы)
- (void)control:(id)sender pullDownProgress:(CGFloat)progress;
@end

typedef NS_ENUM(NSInteger, ImageVerticalAlign) {
    ImageVerticalAlignTop = 0,
    ImageVerticalAlignCenter,
    ImageVerticalAlignBottom,
};

@interface ImageViewControl : UIScrollView <NSCopying>
@property (nonatomic, strong) UIImage *image;
// к "пропорциональному заполнению" добавляется сдвиг при необходимости картинки вниз т.о. чтобы "головы" оставались на виду
@property (nonatomic) BOOL zoomEnabled;
@property (nonatomic, weak) id <ControlPullDownProtocol> pullDownDelegate;
/// настраивать вертикальное выравнивание может понадобится для показа например пласхолдера - его надо прижимать как правило к низу (иначе плечи висят в воздухе); а фото юзера _как правило_ должны показываться прижатыми вверх (чтобы сверху была голова)
@property (nonatomic, assign) ImageVerticalAlign imageVerticalAlign;
@end
