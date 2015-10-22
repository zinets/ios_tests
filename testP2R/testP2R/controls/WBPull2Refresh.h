//
//  WBPull2Refresh.h
//  testP2R
//
//  Created by Zinetz Victor on 23.06.14.
//  Copyright (c) 2014 Cupid plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPull2Refresh : UIView
@property (nonatomic, assign) UIImage * activityImage;
@property (nonatomic, assign) CGFloat progress;

-(void)startRefreshing;
-(void)stopRefreshing;

+(instancetype)refreshIndicator;
@end
