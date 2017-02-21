//
//  ImageView.h
//

#import <UIKit/UIKit.h>

@protocol ControlPullDownProtocol <NSObject>
@required
@property (nonatomic, assign) CGFloat pullDownLimit;
- (void)controlReachedPullDownLimit:(id)sender;
@end

@interface ImageView : UIScrollView <NSCopying>
@property (nonatomic, strong) UIImage *image;
// к "пропорциональному заполнению" добавляется сдвиг при необходимости картинки вниз т.о. чтобы "головы" оставались на виду
@property (nonatomic) BOOL zoomEnabled;
@property (nonatomic, weak) id <ControlPullDownProtocol> pullDownDelegate;
@end
