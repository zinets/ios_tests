//
//  NavViewController.m
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "NavViewController.h"
#import "defines.h"

#import "AnimationManager.h"

@interface NavViewController () <MenuControllerDelegate>
@property (nonatomic, strong) MenuController *menuCtrl;
@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

-(instancetype)init {
    MenuController *mc = [MenuController new];
    if (self = [super initWithRootViewController:mc]) {
        self.delegate = [AnimationManager sharedInstance];
        self.menuCtrl = mc;
        self.menuCtrl.delegate = self;
    }
    return self;
}

+ (instancetype)navigationController {
    return [NavViewController new];
}

#pragma mark - <MenuControllerDelegate>

- (void)menu:(id)sender didSelectItem:(MenuItem)menuItem {
    ControllerKind k;
    switch (menuItem) {
        case MenuItem1:
        case MenuItem3:
            k = ControllerKind1;
            break;
        case MenuItem2:
        case MenuItem4:
            k = ControllerKind2;
            break;
        default:
            NSLog(@"selected %@", @(menuItem));
            break;
    }
    [self sender:self wantAddNewControllerByKind:k];
}

- (UIViewController *)sender:(UIViewController *)sender wantAddNewControllerByKind:(ControllerKind)kind {
    UIViewController *newController = [ControllerFactory controllerByKind:kind];
#if (USE_PUSH)
    [self pushViewController:newController animated:YES];
#else
    newController.transitioningDelegate = [AnimationManager sharedInstance];
    newController.modalPresentationStyle = UIModalPresentationCustom;

    [sender presentViewController:newController animated:YES completion:nil];
#endif
    return newController;
}

@end
