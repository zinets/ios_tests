//
//  DynamicButton.h
//  buttons
//
//  Created by Zinets Victor on 10/27/15.
//  Copyright © 2015 Zinets Victor. All rights reserved.
//

#import "ColorButton.h"
#import "PathHelper.h"

@interface DynamicButton : ColorButton {

}
@property (nonatomic) ButtonStyle buttonStyle;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *highlightStrokeColor;

- (instancetype)initWithStyle:(ButtonStyle)style;
@end
