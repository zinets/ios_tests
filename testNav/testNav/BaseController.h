//
//  BaseController.h
//
//  Created by Zinets Victor on 10/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#warning
    // это все равно как-то нелогично, надо какой-то "раутер"
#import "NavViewController.h"

@interface BaseController : UIViewController
@property (nonatomic, strong) NSString *viewTitle;
@end
