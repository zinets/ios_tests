//
//  NavViewController.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavViewController.h"

#import "UpDownTransitionAnimator.h"
#import "PushTransitionAnimator.h"

typedef NS_ENUM(NSUInteger, InteractiveState) {
    InteractiveStateNone,
    InteractiveStatePushingUp, // "пушить" можно только вверх интерактивно - тот контроллер, который сдвинули вниз
    InteractiveStatePoppingDown,
    InteractiveStatePoppingRight,
};

@interface NavViewController () <UINavigationControllerDelegate> {
    UIPanGestureRecognizer* panRecognizer;
}
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
// меню
@property (nonatomic, strong) MenuController *menu;
// последний видимый контроллер
@property (nonatomic, strong) BaseViewController *lastVisibleController;
// текущий аниматор(ы)
@property (nonatomic, strong) TransitionAnimator *appearingAnimator;
@property (nonatomic, strong) TransitionAnimator *disappearingAnimator;
// какая-никакая а оптимизация
@property (nonatomic, strong) TransitionAnimator *upDownAnimator;
@property (nonatomic, strong) TransitionAnimator *pushAnimator;
// что сейчас происходит в смысле интерактивного перехода
@property (nonatomic) InteractiveState interactiveState;
@end

@implementation NavViewController

- (instancetype)init {
    self.menu = [MenuController new];
    if (self = [super initWithRootViewController:self.menu]) {
        self.navigationBarHidden = YES;
        self.delegate = self;

        self.menu.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    self.menu.gestureRecognizer = panRecognizer;
}

#pragma mark - getters

-(TransitionAnimator *)upDownAnimator {
    if (!_upDownAnimator) {
        _upDownAnimator = [UpDownTransitionAnimator new];
    }
    return _upDownAnimator;
}

-(TransitionAnimator *)pushAnimator {
    if (!_pushAnimator) {
        _pushAnimator = [PushTransitionAnimator new];
    }
    return _pushAnimator;
}

#pragma mark - menu delegation

- (void)menu:(id)sender didSelectItem:(MenuItem)menuItem {
    ControllerKind kind;
    switch (menuItem) {
        case MenuItem1:
        case MenuItem3:
            kind = ControllerKind1;
            break;
            
        case MenuItem2:
        case MenuItem4:
            kind = ControllerKind2;
            break;
    }
    [self pushViewControllerOfKind:kind animated:YES];
}

#pragma mark - pan delegate

- (void)onPan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            
            switch (self.viewControllers.count) {
                case 1: // только меню
                    self.interactiveState = InteractiveStatePushingUp;
                    [self pushViewController:self.lastVisibleController animated:YES];
                    break;
                case 2: // "главный" контроллер (один из); может сдвинуться только вниз
                    if (translation.y > 0) {
                        self.interactiveState = InteractiveStatePoppingDown;
                        [self popViewControllerAnimated:YES];
                    }
                    break;
                default:
#warning
                    // если у нас > 2 контроллера - это значит например
                    // меню -> профиль -> переписки; и отсюда можно И вернутся влево на пред. контроллер, И перейти вниз к меню!! omfg!
                    // если translkation.y > 0 - значит можно сделать popToRoot
                    if (translation.x > 0) {
                        self.interactiveState = InteractiveStatePoppingRight;
                        [self popViewControllerAnimated:YES];
                    }
                    break;
            }
            
            break;
        case UIGestureRecognizerStateChanged: {
            switch (self.interactiveState) {
                case InteractiveStatePoppingRight: {
                    CGFloat percent = fabs(MAX(0, translation.x) / self.view.bounds.size.width);
                    [self.interactionController updateInteractiveTransition:percent];
                } break;
                case InteractiveStatePushingUp: {
                    CGFloat percent = fabs(MAX(0, -translation.y) / self.view.bounds.size.height);
                    [self.interactionController updateInteractiveTransition:percent];
                } break;
                case InteractiveStatePoppingDown: {
                    CGFloat percent = fabs(MAX(0, translation.y) / self.view.bounds.size.height);
                    [self.interactionController updateInteractiveTransition:percent];
                }
                default:
                    break;
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            if ((self.interactiveState == InteractiveStatePoppingRight && [recognizer velocityInView:self.view].x > 0) ||
                (self.interactiveState == InteractiveStatePoppingDown && [recognizer velocityInView:self.view].y > 0) ||
                (self.interactiveState == InteractiveStatePushingUp && [recognizer velocityInView:self.view].y < 0)) {
                [self.interactionController finishInteractiveTransition];
            } else {
                [self.interactionController cancelInteractiveTransition];
            }
            self.interactionController = nil;
            self.interactiveState = InteractiveStateNone;
        } break;
        default:
            break;
    }
}

#pragma mark - public

- (void)pushViewControllerOfKind:(ControllerKind)kind animated:(BOOL)animated {
    UIViewController *ctrl = nil;
    if ([self.lastVisibleController isKindOfClass:[ControllerFactory controllerClassForKind:kind]]) {
        ctrl = self.lastVisibleController;
    } else {
        ctrl = [ControllerFactory controllerByKind:kind];
    }    

    [self pushViewController:ctrl animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self preparePush];
    [super pushViewController:viewController animated:animated];
    {
        [viewController.view addGestureRecognizer:panRecognizer];
    }

}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self preparePop];
#warning 
    // не вляпаюсь ли я в "не тот тип"?
    self.lastVisibleController = (id)[super popViewControllerAnimated:animated];
    
    
    return self.lastVisibleController;
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    self.lastVisibleController = nil;
#warning 
    // абсрактное предупреждение - надо ли визуально для такого случая оставлять снизу кусочек вью? какого вью?? а может и не абсрактное - если мы открыли голосовалку -> открыли профиль -> перешли в переписку и нажимаем кнопку "V" - это же и есть  возврат к корню
    // ох будет геморой..
    return [super popToRootViewControllerAnimated:animated];
}

#pragma mark - self delegation

// класс для "обычной" анимации пуша или попа
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    switch (operation) {
        case UINavigationControllerOperationPush:
            self.appearingAnimator.newControllerOnScreen = self.lastVisibleController == toVC;
            self.appearingAnimator.presenting = YES;
            return self.appearingAnimator;
        case UINavigationControllerOperationPop:
            self.disappearingAnimator.presenting = NO;
            return self.disappearingAnimator;
        default:
            return nil;
    }
}

// класс для интерактивного перехода
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    // тут я залип и до конца не понял; класс должен конформить/наследоваться от определенных класов/протоколов, тем не менее в начале пана создается "абсрактный" класс "процентногоПерехода" и вызывается pop (в теории пофиг что вызывается, может быть и пуш) и отсюда вернется тот класс (реализации которого нет!), попутно вызовется и метод чуть выше и вернется аниматор (который предоставляет анимацию "полную" и законченную)
    // и как этот (interactionController == UIPercentDrivenInteractiveTransition) класс анимирует нужный момент времени - хз
    // но работает же!
    return self.interactionController;
}

#pragma mark - states

- (void)preparePush {
    if (self.viewControllers.count < 2) {
        self.appearingAnimator = self.upDownAnimator;
    } else {
        self.appearingAnimator = self.pushAnimator;
    }
}

- (void)preparePop {
    if (self.viewControllers.count < 3) {
        self.disappearingAnimator = self.upDownAnimator;
    } else {
        self.disappearingAnimator = self.pushAnimator;
    }
}


@end
