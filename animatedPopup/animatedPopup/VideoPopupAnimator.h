//
//  VideoPopupAnimator.h
//  animatedPopup
//
//  Created by Zinets Viktor on 5/30/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavProtocols.h"

@interface VideoPopupAnimator : NSObject <NavigationAnimator>
@property (nonatomic, assign) UINavigationControllerOperation operation;
@end
