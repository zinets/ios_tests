//
//  BlindRemainingView.h
//  blindActivityIndicator
//
//  Created by Victor Zinets on 11/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlindRemainingView : UIView
@property (nonatomic) NSTimeInterval remainingTime;
@property (nonatomic) NSTimeInterval overallTime;

/// ширина опоясывающей линии
@property (nonatomic) CGFloat lineWidth;
/// отступ от линии до контента; т.е. размер контента меньше размера контрола с каждой стороны на lineWidth + lineSpace
@property (nonatomic) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, weak) UIView *embeddedView;

@end

NS_ASSUME_NONNULL_END
