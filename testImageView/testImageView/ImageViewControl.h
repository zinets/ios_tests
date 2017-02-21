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

@interface ImageViewControl : UIScrollView <NSCopying>
@property (nonatomic, strong) UIImage *image;
// к "пропорциональному заполнению" добавляется сдвиг при необходимости картинки вниз т.о. чтобы "головы" оставались на виду
@property (nonatomic) BOOL zoomEnabled;
@property (nonatomic, weak) id <ControlPullDownProtocol> pullDownDelegate;
@end
