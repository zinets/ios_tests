//
//  ProgressBlock.h
//  gradProgress
//
//  Created by Zinets Victor on 1/5/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBlock : UIView
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic, strong) UIColor *inactiveColor;
@property (nonatomic) CGFloat progress;
@end
