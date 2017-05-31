//
//  VideoPopupAnimator.h
//  animatedPopup
//
//  Created by Zinets Viktor on 5/30/17.
//  Copyright © 2017 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavProtocols.h"

@interface VideoPopupAnimator : NSObject <NavigationAnimator>
@property (nonatomic, assign) UINavigationControllerOperation operation;

/// размер основного элемента (круг под галочку), 160 пк для 4.7"
@property (nonatomic) CGFloat circleDiameter;
/// размер разбегающегося круга (смотреть анимацию в принципле, сложно все пересказывать)
@property (nonatomic) CGFloat lightCircleDiameter;
/// "основной" цвет контроллера, который появляется (зелененький)
@property (nonatomic, strong) UIColor *shapeColor;

@end
