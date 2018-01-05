//
// Created by Zinets Viktor on 1/5/18.
// Copyright (c) 2018 Zinets Viktor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedView : UIView
@property (nonatomic) UIRectCorner corners;
@property (nonatomic) CGFloat cornerRadius;
// цветом фона закрашивается или сам балун, или бордер вокруг него (сам балун тогда белый)
@property (nonatomic) BOOL isBorderVisible;
@end