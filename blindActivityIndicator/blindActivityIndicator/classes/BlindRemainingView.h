//
//  BlindRemainingView.h
//  blindActivityIndicator
//
//  Created by Victor Zinets on 11/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BlindRemainingViewDelegate <NSObject>
@required
- (void)remainingDidEnd:(id)sender;
@end

IB_DESIGNABLE
@interface BlindRemainingView : UIView
@property (nonatomic) NSTimeInterval overallTime;

/// ширина опоясывающей линии
@property (nonatomic) IBInspectable CGFloat lineWidth;
/// отступ от линии до контента; т.е. размер контента меньше размера контрола с каждой стороны на lineWidth + lineSpace
@property (nonatomic) IBInspectable CGFloat lineSpace;
@property (nonatomic, strong) IBInspectable UIColor *lineColor;

@property (nonatomic, weak) UIView *embeddedView;
@property (nonatomic) IBInspectable BOOL textRemainVisible;
@property (nonatomic, weak) IBOutlet id<BlindRemainingViewDelegate> delegate;

- (void)stopTimer;
- (void)pauseTimer;
- (void)startTimer;

@end

NS_ASSUME_NONNULL_END
