//
//  PopupController.m
//  animatedPopup
//
//  Created by Zinets Viktor on 5/30/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import "PopupController.h"
#import "ColorButton.h"
#import "VideoPopupAnimator.h"

@interface PopupController ()
@property (weak, nonatomic) IBOutlet ColorButton *button;

@end

@implementation PopupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button.backgroundColor = [UIColor whiteColor];
    self.button.layer.cornerRadius = 20;
}

-(NSObject<NavigationAnimator> *)animator {
    if (!_animator) {
        _animator = [VideoPopupAnimator new];
    }
    return _animator;
}

@end
