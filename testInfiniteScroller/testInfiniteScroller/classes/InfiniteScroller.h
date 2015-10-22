//
//  InfiniteScroller.h
//  testInfiniteScroller
//
//  Created by Zinetz Victor on 05.03.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfiniteScroller;
@protocol InfiniteScrollerDataSource <NSObject>

-(NSInteger)infiniteScrollerItemsCount:(InfiniteScroller *)scroller;
-(UIView *)infiniteScroller:(InfiniteScroller *)scroller viewForIndex:(NSInteger)index;

@end

@interface InfiniteScroller : UIScrollView

@property (weak, nonatomic) id<InfiniteScrollerDataSource>dataSource;
@property (assign, nonatomic) CGFloat cellSize; // предполагаем, что ячейка квадрат

-(void)reloadData;
-(UIView *)dequeueReusableView;

@end
