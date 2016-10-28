//
//  UpDownTransitionAnimator.m
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "UpDownTransitionAnimator.h"
#warning 
// аниматор будет знать о типе "контроллерМеню" - нехорошо, а как иначе?
#import "MenuController.h"

// это отступ сверху, на который не доезжает контроллер при пуше до верха экрана
static CGFloat const topOffsetValue = 30.;
// это отступ снизу, на который не доезжает до низа убираемый контроллер
static CGFloat const bottomOffsetValue = 40.;
@interface UpDownTransitionAnimator ()
@end

@implementation UpDownTransitionAnimator

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.presenting) {
#warning 
        // связанность, мать ее; для правильности и красоты можно придумать протокол контроллера, который используется в одной из фаз анимации (со свойством footerView)
        MenuController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect rect = [UIScreen mainScreen].bounds;
        CGFloat dy = rect.size.height + (self.newControllerOnScreen ? -bottomOffsetValue : 0);
        rect.origin.y += dy;
        rect.size.height -= topOffsetValue;
        
        toViewController.view.frame = rect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
            CGRect rect = toViewController.view.frame;
            rect.origin.y = topOffsetValue;
            toViewController.view.frame = rect;
            
            fromViewController.view.layer.cornerRadius = 5;
        } completion:^(BOOL finished) {
            { // сука, я сам не верю, что нельзя проще, но не нашел способа пока
                CGSize sz = [UIScreen mainScreen].bounds.size;
                UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
                
                [fromViewController.view.window drawViewHierarchyInRect:(CGRect){CGPointZero, sz}
                                                     afterScreenUpdates:NO];
                
                UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                UIView *fakeView = [[UIImageView alloc] initWithImage:img];
                fakeView.tag = MAGIC_TAG_TOP_PIECE;
                fakeView.contentMode = UIViewContentModeTop;
                fakeView.frame = (CGRect){{0, -topOffsetValue}, {sz.width, topOffsetValue}};
                [toViewController.view addSubview:fakeView];
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    } else {
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        MenuController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        UIView *fakeHeader = [fromViewController.view viewWithTag:MAGIC_TAG_TOP_PIECE];
        if (fakeHeader) {
            [fakeHeader removeFromSuperview];
        }
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        CGRect rect = [transitionContext initialFrameForViewController:fromViewController];
        rect.origin.y += rect.size.height - bottomOffsetValue;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = rect;
            toViewController.view.layer.cornerRadius = 0;
            toViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) { // отменили - вернем сверху фейковый кусочек
                [fromViewController.view addSubview:fakeHeader];
            } else { // еще лопата гамнокода
                CGSize sz = [UIScreen mainScreen].bounds.size;
                UIGraphicsBeginImageContextWithOptions(sz, NO, 0);
                
                [fromViewController.view.window drawViewHierarchyInRect:(CGRect){CGPointZero, sz}
                                                     afterScreenUpdates:NO];
                
                UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                UIView *fakeView = [[UIImageView alloc] initWithImage:img];
                fakeView.contentMode = UIViewContentModeBottom;
                fakeView.frame = (CGRect){{0, sz.height - bottomOffsetValue}, {sz.width, bottomOffsetValue}};
                toViewController.footerView = fakeView;
            }
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (CGFloat)interactivePercent:(CGPoint)translation inBounds:(CGRect)bounds {
    CGFloat percent = 0;
    if (self.presenting) {
        percent = fabs(MAX(0, -translation.y) / bounds.size.height);
    } else {
        percent = fabs(MAX(0, translation.y) / bounds.size.height);
    }
    return percent;
}

@end
