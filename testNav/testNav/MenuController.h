//
//  MenuController.h
//  testNav
//
//  Created by Zinets Victor on 10/21/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MenuItem1,
    MenuItem2,
    MenuItem3,
} MenuItem;

@protocol MenuControllerDelegate <NSObject>
@required
- (void)menu:(id)sender didSelectItem:(MenuItem)nemuItem;
@end

@interface MenuController : UIViewController
@property (nonatomic, weak) id <MenuControllerDelegate> delegate;
@end
