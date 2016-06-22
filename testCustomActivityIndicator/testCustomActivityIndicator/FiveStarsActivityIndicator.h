//
//  FiveStarsActivityIndicator.h
//  testCustomActivityIndicator
//
//  Created by Zinets Victor on 6/22/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AnimationStage) {
    AnimationStageStart = 1,
    AnimationStageCollapsing,
    AnimationStageFinishing,
};

@interface FiveStarsActivityIndicator : UIView
- (void)setStage:(AnimationStage)stage;
@end
