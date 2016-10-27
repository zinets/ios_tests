//
//  MenuController.h
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MenuItem1,
    MenuItem2,
    MenuItem3,
    MenuItem4,
} MenuItem;

@protocol MenuControllerDelegate <NSObject>
@required
- (void)menu:(id)sender didSelectItem:(MenuItem)menuItem;
@end

@interface MenuController : UIViewController
@property (nonatomic, weak) id <MenuControllerDelegate> delegate;
// декоративный элемент, торчит снизу и создает видимость задвинутого вниз контроллера
@property (nonatomic, strong) UIView *footerView;
// причина по которой мне нужна эта проперть - в конце анимации "вниз" к меню добавляется фейковый элемент снизу, который олисестворяет задвинутый вниз контроллер; за этот элемент этот контроллер ножно вытянуть вверх (запушить фактич.), но элемент добавляется к меню в конце анимации
// к этому элементу надо добавить рекогнайзер (обработчик которого в навконтроллере), но уже нет точки, где это сделать; поэтому я запоминаю рекогнайзер как свойство меню при созджании меню, а меню потом будет назначать рекогнайзер своему фиктивному подвалу; ну идея такая вот
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;
@end
