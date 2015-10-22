//
//  InfiniteScroller.m
//  testInfiniteScroller2
//
//  Created by Zinetz Victor on 07.03.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "InfiniteScroller.h"

@implementation InfiniteScroller

#define default_cell_size   110.0f

@synthesize cellSize;
@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        items = [NSMutableArray arrayWithCapacity:100];
        
        self.cellSize = default_cell_size;
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self recalcCells];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    CGFloat minimumVisibleX = CGRectGetMinX(self.bounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(self.bounds);
    CGFloat minimumVisibleY = CGRectGetMinY(self.bounds);
    CGFloat maximumVisibleY = CGRectGetMaxY(self.bounds);
    
    if (items.count < rows * columns) {
        for (int x = items.count; x < rows * columns; x++) {
            CGFloat xpos = x / rows * cellSize;
            CGFloat ypos = x % rows * cellSize;

            NSInteger index = x % itemsCount; //[self getMaxIndex];
            UILabel * label = (UILabel *)[self.dataSource scroller:self viewForIndex:index reuseView:nil];
            label.tag = x % itemsCount;

            label.frame = CGRectMake(xpos, ypos, cellSize, cellSize);
            [items addObject:label];
            [self addSubview:label];
        }
    }
    
    // листаем влево - новые ячейки появляются справа
    UIView * view = [items lastObject];
    NSInteger index = view.tag;
    CGFloat rightEdge = CGRectGetMaxX([view frame]);
    while (rightEdge < maximumVisibleX) {
        CGRect frame = [self getNextFrame];
        
        view = items[0];
        [items removeObjectAtIndex:0];
        index = ++index % itemsCount;
        view = [self.dataSource scroller:self viewForIndex:index reuseView:view];
        view.tag = index;
        [items addObject:view];
        view.frame = frame;
        
        rightEdge = CGRectGetMaxX([view frame]);
        
        CGFloat bottomEdge = CGRectGetMaxY([view frame]);
        while (bottomEdge < maximumVisibleY) {
            CGRect frame = [self getNextFrame];
            
            view = items[0];
            index = (index + 1) % itemsCount;
            [items removeObjectAtIndex:0];
            view = [self.dataSource scroller:self viewForIndex:index reuseView:view];
            view.tag = index;
            [items addObject:view];
            view.frame = frame;
            
            bottomEdge = CGRectGetMaxY([view frame]);
        }        
    }
    
    view = [items objectAtIndex:0];
    index = view.tag;
    CGFloat leftEdge = CGRectGetMinX([view frame]);
    while (leftEdge > minimumVisibleX) {
        CGRect frame = [self getPrevFrame];
        
        view = [items lastObject];
        [items removeLastObject];
        index = (index + itemsCount - 1) % itemsCount;
        view = [self.dataSource scroller:self viewForIndex:index reuseView:view];
        view.tag = index;
        [items insertObject:view atIndex:0];
        view.frame = frame;
        
        leftEdge = CGRectGetMinX([view frame]);
        
        CGFloat topEdge = CGRectGetMinY([view frame]);
        while (topEdge > minimumVisibleY) {
            CGRect frame = [self getPrevFrame];
            
            view = [items lastObject];
            [items removeLastObject];
            index = (index + itemsCount - 1) % itemsCount;
            view = [self.dataSource scroller:self viewForIndex:index reuseView:view];
            view.tag = index;
            [items insertObject:view atIndex:0];
            view.frame = frame;
            
            topEdge = CGRectGetMinY([view frame]);
        }
    }
}

#pragma mark - privates

-(CGRect)getPrevFrame {
    CGRect frame = ((UIView *)items[0]).frame;
    frame.origin.y -= cellSize;
    if (frame.origin.y < 0) {
        frame.origin.y = self.frame.size.height - cellSize;
        frame.origin.x -= cellSize;
    }
    
    return frame;
}

-(CGRect)getNextFrame {
    CGRect frame = ((UIView *)[items lastObject]).frame;
    frame.origin.y += cellSize;
    if (frame.origin.y >= self.frame.size.height) {
        frame.origin.y = 0;
        frame.origin.x += cellSize;
    }
    return frame;
}

-(NSInteger)getMaxIndex {
    NSInteger res = -1;
    for (UIView * v in items) {
        res = MAX(v.tag, res);
    }
    
    return res + 1;
}

-(void)recalcCells {
    rows = self.frame.size.height / cellSize;
    columns = self.frame.size.width / cellSize + 1;
    self.contentSize = CGSizeMake(2 * columns * cellSize, self.frame.size.height);
}

- (void)recenterIfNecessary {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > cellSize) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        for (UIView *label in items) {
            CGPoint center = label.center;
            center.x += (centerOffsetX - currentOffset.x);
            label.center = center;            
        }
    }
}

#pragma mark - set/getters

-(void)setCellSize:(CGFloat)newCellSize {
    if (cellSize != newCellSize) {
        cellSize = newCellSize;
        [self recalcCells];
    }
}

#pragma mark - public

-(void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollerItemsCount:)]) {
        itemsCount = [self.dataSource scrollerItemsCount:self];
        [self setNeedsLayout];
    }
}

@end
