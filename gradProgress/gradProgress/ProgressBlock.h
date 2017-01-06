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
/// предполагается значение от 0 до 1
@property (nonatomic) CGFloat progress;

@property (nonatomic, readonly) UILabel *valueLabel;
@property (nonatomic, readonly) UILabel *descriptionLabel;
@end
