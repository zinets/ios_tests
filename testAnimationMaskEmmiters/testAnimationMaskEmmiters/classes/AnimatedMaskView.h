//
// Created by Victor Zinets on 5/18/18.
// Copyright (c) 2018 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedMaskView : UIView
@property (nonatomic, strong) UIImage *image;
-(void)reset;
-(void)animate;
@end