//
//  HexagonCellData.h
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const HexCellDataChanged;

@interface HexagonCellData : NSObject
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic) CGFloat progress;
@end
