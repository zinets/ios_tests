//
//  InfiniteScroller.h
//  testInfiniteScroller2
//
//  Created by Zinetz Victor on 07.03.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfiniteScroller;
@protocol InfiniteScrollerDataSource <NSObject>
@required
-(NSInteger)scrollerItemsCount:(InfiniteScroller *)scroller;
-(UIView *)scroller:(InfiniteScroller *)scroller viewForIndex:(NSInteger)index reuseView:(UIView *)view;
@end

@interface InfiniteScroller : UIScrollView {
    NSMutableArray * items;
    NSInteger columns;
    NSInteger rows;
    NSInteger itemsCount;
}

@property (assign, nonatomic) CGFloat cellSize;
@property (weak, nonatomic) id<InfiniteScrollerDataSource>dataSource;

-(void)reloadData;

@end

#define RGB3(color)  [UIColor colorWithRed:((color & 0xff0000) >> 16) / 255.0f \
green:((color & 0xff00) >> 8) / 255.0f \
blue:(color & 0xff) / 255.0f \
alpha:1.0]