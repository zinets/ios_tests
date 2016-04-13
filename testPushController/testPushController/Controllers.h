//
//  Controller1.h
//  testPushController
//
//  Created by Zinets Victor on 4/13/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController
@property (nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly) NSString *text;
@end


@interface Controller0 : BaseController
@end

@interface Controller1 : BaseController {
    UIButton *button;
}
@end

@interface Controller2 : BaseController
@end