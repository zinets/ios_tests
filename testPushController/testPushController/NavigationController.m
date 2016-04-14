//
//  NavigationController.m
//  testPushController
//
//  Created by Zinets Victor on 4/14/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavigationController.h"
#import "PushAnimator.h"

@interface NavigationController ()  <UINavigationControllerDelegate> {
    
}
@property (nonatomic, weak) NSObject <NavigationAnimator> *animator;
@end

@implementation NavigationController

//-(instancetype)initWithRootViewController:(UIViewController *)rootViewController {
//    if (self = [super initWithRootViewController:rootViewController]) {
//        self.view.backgroundColor = [UIColor orangeColor];
//        
//        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"t0"]];
//        iv.center = (CGPoint){160, 250};
//        [self.view insertSubview:iv atIndex:0];
//    }
//    return self;
//}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController conformsToProtocol:@protocol(CustomNavigationAnimation)]) {
        UIViewController <CustomNavigationAnimation> *vc = (id)viewController;
        _animator = vc.animator;
        self.delegate = self;
    } else {
        self.delegate = nil;
        self.animator = nil;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *res = [super popViewControllerAnimated:animated];
    
    UIViewController *viewController = self.visibleViewController;
    if ([viewController conformsToProtocol:@protocol(CustomNavigationAnimation)]) {
        UIViewController <CustomNavigationAnimation> *vc = (id)viewController;
        self.animator = vc.animator;
        self.delegate = self;
    } else {
        self.delegate = nil;
        self.animator = nil;
    }
    
    return res;
}

-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *res = [super popToViewController:viewController animated:animated];

    UIViewController *ctrl = self.visibleViewController;
    if ([ctrl conformsToProtocol:@protocol(CustomNavigationAnimation)]) {
        UIViewController <CustomNavigationAnimation> *vc = (id)ctrl;
        self.animator = vc.animator;
        self.delegate = self;
    } else {
        self.delegate = nil;
        self.animator = nil;
    }

    return res;
}

-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *res = [super popToRootViewControllerAnimated:animated];

    UIViewController *ctrl = self.visibleViewController;
    if ([ctrl conformsToProtocol:@protocol(CustomNavigationAnimation)]) {
        UIViewController <CustomNavigationAnimation> *vc = (id)ctrl;
        self.animator = vc.animator;
        self.delegate = self;
    } else {
        self.delegate = nil;
        self.animator = nil;
    }

    return res;
}

#pragma mark - navigation

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if (self.animator) {
        self.animator.operation = operation;
    }
    
    return self.animator;
}

@end
