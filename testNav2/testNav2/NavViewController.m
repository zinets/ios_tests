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
@property (nonatomic, strong) NSArray <BaseViewController *> *lastVisibleControllers;
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
                    if (translation.y < 0) { // только поднимание вверх!
                        self.interactiveState = InteractiveStatePushingUp;
#warning 
                        // теперь здесь может восстановится как 1 контроллер, так и неск; соотв. надо другой метод?
                        [self pushViewControllers:self.lastVisibleControllers animated:YES];
                    }
                    break;
                default:
                    if (translation.x > 0 && self.viewControllers.count > 2) {
                        self.interactiveState = InteractiveStatePoppingRight;
                        [self popViewControllerAnimated:YES];
                    } else if (translation.y > 0) {
                        self.interactiveState = InteractiveStatePoppingDown;
                        [self popToRootViewControllerAnimated:YES];
                    }
                    break;
            }
            break;
        case UIGestureRecognizerStateChanged: {
            switch (self.interactiveState) {
                case InteractiveStatePoppingRight: {
#warning 
                    // и следующие 3 кейса - надо убрать "хардкоды" и привязаться как-то к свойствам аниматора (направление сдвига - вверх или в сторону и знак)
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
            switch (self.interactiveState) {
                case InteractiveStatePoppingRight:
                    if ([recognizer velocityInView:self.view].x > 0) {
                        [self.interactionController finishInteractiveTransition];
                    } else {
                        [self.interactionController cancelInteractiveTransition];
                        [[self.lastVisibleControllers lastObject].view addGestureRecognizer:panRecognizer];
                    }
                    break;
                case InteractiveStatePoppingDown:
                    if ([recognizer velocityInView:self.view].y > 0) {
                        [self.interactionController finishInteractiveTransition];
                    } else {
                        [self.interactionController cancelInteractiveTransition];
                        [[self.lastVisibleControllers lastObject].view addGestureRecognizer:panRecognizer];
                    }
                    break;
                case InteractiveStatePushingUp:
                    if ([recognizer velocityInView:self.view].y < 0) {
                        [self.interactionController finishInteractiveTransition];
                    } else {
                        [self.interactionController cancelInteractiveTransition];
                        [[self.lastVisibleControllers lastObject].view addGestureRecognizer:panRecognizer];
                    }
                default:
                    break;
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
    if ([[self.lastVisibleControllers lastObject] isKindOfClass:[ControllerFactory controllerClassForKind:kind]]) {
        ctrl = [self.lastVisibleControllers lastObject];
    } else {
        ctrl = [ControllerFactory controllerByKind:kind];
    }    

    [self pushViewController:ctrl animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self preparePush];
    [super pushViewController:viewController animated:animated];
    [viewController.view addGestureRecognizer:panRecognizer];
}

- (void)pushViewControllers:(NSArray <BaseViewController *> *)viewControllers animated:(BOOL)animated {
    // после popToRoot остается массив контроллеров, которые уехали - кроме собств. root (в нашем случае это меню)
    // вернуть их назад можно методом setVControllers:animated: - но метод заменит весь стек, т.е. потеряем меню
    NSArray <UIViewController *> *resArray = [@[self.menu] arrayByAddingObjectsFromArray:self.lastVisibleControllers];
    [self preparePush]; // настройка аниматора
    [self setViewControllers:resArray animated:YES];
    
    [[resArray lastObject].view addGestureRecognizer:panRecognizer];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self preparePop];

    self.lastVisibleControllers = @[[super popViewControllerAnimated:animated]];
    if (self.topViewController != self.menu) {
        [self.topViewController.view addGestureRecognizer:panRecognizer];
    }
    
    return [self.lastVisibleControllers lastObject];
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [self preparePop];
    self.lastVisibleControllers = [super popToRootViewControllerAnimated:animated];
    
    return self.lastVisibleControllers;
}

#pragma mark - self delegation

// класс для "обычной" анимации пуша или попа
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    switch (operation) {
        case UINavigationControllerOperationPush:
            self.appearingAnimator.newControllerOnScreen = [self.lastVisibleControllers lastObject] == toVC;
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
    switch (self.interactiveState) {
        case InteractiveStatePushingUp:
            self.appearingAnimator = self.upDownAnimator;
            break;
        default:
            if (self.viewControllers.count < 2) {
                self.appearingAnimator = self.upDownAnimator;
            } else {
                self.appearingAnimator = self.pushAnimator;
            }            
            break;
    }
}

- (void)preparePop {
    switch (self.interactiveState) {
        case InteractiveStatePoppingDown:
            self.disappearingAnimator = self.upDownAnimator;
            break;
        case InteractiveStatePoppingRight:
            self.disappearingAnimator = self.pushAnimator;
            break;
        default:
            if (self.viewControllers.count < 3) {
                self.disappearingAnimator = self.upDownAnimator;
            } else {
                self.disappearingAnimator = self.pushAnimator;
            }
            break;
    }
}


@end
