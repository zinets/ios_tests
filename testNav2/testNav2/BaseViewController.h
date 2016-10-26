//
//  BaseViewController.h
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController {
    UILabel *_titleLabel;
}
@property (nonatomic, strong) NSString *viewTitle;

@end
