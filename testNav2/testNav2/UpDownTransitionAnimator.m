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

#warning magic is here
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

        CGRect endRect = [UIScreen mainScreen].bounds;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        __block CGRect startRect = endRect;
        startRect.origin.y += startRect.size.height + (self.newControllerOnScreen ? -bottomOffsetValue : 0);
        toViewController.view.frame = startRect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
            startRect.origin.y = topOffsetValue;
            toViewController.view.frame = startRect;
            
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
        
        CGRect endRect = [transitionContext initialFrameForViewController:fromViewController];
        endRect.origin.y += endRect.size.height - (topOffsetValue + bottomOffsetValue);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endRect;
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

@end
