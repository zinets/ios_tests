//
//  TransitionAnimator.h
//  testNav2
//
//  Created by Zinets Victor on 10/26/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

#warning 
// magic
static int const MAGIC_TAG_TOP_PIECE  = 0x238929;

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, getter = isPresenting) BOOL presenting;
#warning 
// переименовать? мы говорим аниматору, что сейчас выдвинется контроллер, который как-бы сейчас внизу на экране (т.е. который перед этим типа задвинули вниз)
@property (nonatomic, assign) BOOL newControllerOnScreen;
/// для определения процента завершенности я буду использовать метод аниматора - который знает а) свой тип, т.е. какую координату использовать б) направление движения
- (CGFloat)interactivePercent:(CGPoint)translation inBounds:(CGRect)bounds;
@end
