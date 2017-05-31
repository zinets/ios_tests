//
//  PopupController.h
//  animatedPopup
//
//  Created by Zinets Viktor on 5/30/17.
//  Copyright (c) 2017 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavProtocols.h"

@interface PopupController : UIViewController <CustomNavigationAnimation>
@property (nonatomic, strong) NSObject <NavigationAnimator> *animator;
@end
