//
//  ViewController.h
//  supplTest
//
//  Created by Zinets Victor on 12/15/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGLGuillotineMenu.h"

@interface ViewController : UIViewController <TGLGuillotineMenuDelegate>
@property (nonatomic, weak) TGLGuillotineMenu *menu;

@end

