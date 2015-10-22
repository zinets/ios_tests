//
//  UIView_ActivityIndicator.h
//  testVineActivity
//
//  Created by Zinets Victor on 4/20/15.
//  Copyright (c) 2015 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlirtActivityIndicator <NSObject>
- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
@end
