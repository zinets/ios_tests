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

@interface NavViewController () <UINavigationControllerDelegate> {
    UIPanGestureRecognizer* panRecognizer;
}
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBarHidden = YES;
    
    self.delegate = self;
    
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
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
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [recognizer translationInView:self.view];
            CGFloat percent = fabs(MAX(0, translation.y) / self.view.bounds.size.height);
            [self.interactionController updateInteractiveTransition:percent];
        } break;
        case UIGestureRecognizerStateEnded: {
            if ([recognizer velocityInView:self.view].y > 0) {
                [self.interactionController finishInteractiveTransition];
            } else {
                [self.interactionController cancelInteractiveTransition];
            }
            self.interactionController = nil;
        } break;
        default:
            break;
    }
}

#pragma mark - public

- (void)pushViewControllerOfKind:(ControllerKind)kind animated:(BOOL)animated {
    UIViewController *ctrl = [ControllerFactory controllerByKind:kind];
    { // сомнительно - вот так вот назначать рекогнайзер
        [ctrl.view addGestureRecognizer:panRecognizer];
    }
    [self pushViewController:ctrl animated:animated];
}

#pragma mark - self delegation

// класс для "обычной" анимации пуша или попа
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    TransitionAnimator *animator = [UpDownTransitionAnimator new];
    animator.presenting = operation == UINavigationControllerOperationPush;
    
    return animator;
}

// класс для интерактивного перехода
-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    // тут я залип и до конца не понял; класс должен конформить/наследоваться от определенных класов/протоколов, тем не менее в начале пана создается "абсрактный" класс "процентногоПерехода" и вызывается pop (в теории пофиг что вызывается, может быть и пуш) и отсюда вернется тот класс (реализации которого нет!), попутно вызовется и метод чуть выше и вернется аниматор (который предоставляет анимацию "полную" и законченную)
    // и как этот (interactionController == UIPercentDrivenInteractiveTransition) класс анимирует нужный момент времени - хз
    // но работает же!
    return self.interactionController;
}

@end
