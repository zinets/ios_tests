//
//  AnimationManager.h
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationManager : NSObject <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
+ (instancetype)sharedInstance;
@end
