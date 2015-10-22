//
//  InfiniteScroller.m
//  testInfiniteScroller
//
//  Created by Zinetz Victor on 05.03.13.
//  Copyright (c) 2013 Cupid plc. All rights reserved.
//

#import "InfiniteScroller.h"
#import "UIView+Geometry.h"

@interface InfiniteScroller () {
    NSInteger cols;
    NSInteger rows;
    NSInteger itemsCount;
    NSMutableArray * items;
    NSMutableArray * reusableItems;
    NSInteger firstVisible;
}

@end

#pragma mark - implementation

@interface InternalItem : NSObject 
@property (assign, nonatomic) CGRect frame;
@property (strong, nonatomic) UIView * view;
@end

@implementation InternalItem
@synthesize frame;
@synthesize view;
-(void)dealloc {
    if (view) {
        [view removeFromSuperview];
    }
}
@end

#define side_offset 15
#define cell_space  15

@implementation InfiniteScroller

@synthesize dataSource;
@synthesize cellSize = _cellSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(2 * self.width, self.height);
        _cellSize = 96;
        firstVisible = -1;
        items = [NSMutableArray arrayWithCapacity:100];
        reusableItems = [NSMutableArray arrayWithCapacity:100];
    }
    return self;
}

-(BOOL)columnIsVisible:(NSInteger)column {
    for (int x = 0; x < cols; x++) {
        if (column == (firstVisible + x) % cols)
            return YES;
    }
    return NO;
}

//-(void)layoutSubviews {
//    CGPoint currentOffset = [self contentOffset];
//    CGFloat contentWidth = [self contentSize].width;
//    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
//    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
//    BOOL shiftToRight = currentOffset.x > centerOffsetX; // первая видимая колонка сдвигается вправо
//    
//    if (distanceFromCenter > _cellSize + cell_space) {
//        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
//        if (shiftToRight) {
//            firstVisible++;
//            if (firstVisible >= cols)
//                firstVisible = 0;
//        } else {
//            firstVisible--;
//            if (firstVisible < 0)
//                firstVisible = cols - 1;
//        }
//
//        for (int x = 0; x < rows * cols; x++) {
//            if ([self columnIsVisible:x / rows] && items[x] == [NSNull null]) {
//                UIView * view = [self.dataSource infiniteScroller:self viewForIndex:x % itemsCount];
//                items[x] = view;
//                CGRect f = CGRectMake(side_offset + (x / rows) * (_cellSize + cell_space), side_offset + x % rows * (_cellSize + cell_space), _cellSize, _cellSize);
//                view.frame = f;
//                [self addSubview:view];
//            }
//        }
//
//        
//        NSLog(@"first visible column - %d", firstVisible);
//        for (id obj in items) {
//            if ([obj isKindOfClass:[UIView class]]) {
//                UIView * view = obj;
//                CGPoint center = view.center;
//                center.x += centerOffsetX - currentOffset.x;
//                view.center = center;
//                
//                if (!CGRectIntersectsRect(view.frame, self.bounds)) {
//                    
//                }
//            }
//        }
//    }
//}

-(void)layoutSubviews {
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    for (int x = 0; x < rows * cols; x++) {
        CGRect f = CGRectMake(side_offset + (x / rows) * (_cellSize + cell_space), side_offset + x % rows * (_cellSize + cell_space), _cellSize, _cellSize);
        
        InternalItem * i = items[x];
        i.frame = f;
        
        NSLog(@"cell %d, frame %@", x, NSStringFromCGRect(f));
        
        if (CGRectIntersectsRect(self.bounds, f)) {
            if (!i.view) {
                UIView * view = [self.dataSource infiniteScroller:self viewForIndex:x % itemsCount];
                i.view = view;
                
                view.frame = f;
                [self addSubview:view];
            }
        } else {
            if (i.view) {
                [i.view removeFromSuperview];
                [reusableItems addObject:i.view];
                i.view = nil;
            }
        }        
    }
    
    if (distanceFromCenter > _cellSize + cell_space) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
    }
    
    for (int x = 0; x < rows * cols; x++) {
        InternalItem * i = items[x];
        CGRect f = i.frame;
        f.origin.x += centerOffsetX - currentOffset.x;
        i.frame = f;
        if (CGRectIntersectsRect(self.bounds, f)) {
            if (!i.view) {
                UIView * view = [self.dataSource infiniteScroller:self viewForIndex:x % itemsCount];
                i.view = view;
                
                view.frame = f;
                [self addSubview:view];
            }
        } else {
            if (i.view) {
                [i.view removeFromSuperview];
                [reusableItems addObject:i.view];
                i.view = nil;
            }
        }
    }
}

#pragma mark - private

-(void)recalcCells {
    rows = (self.height - 2 * side_offset) / (_cellSize + cell_space);
    cols = ceilf(itemsCount / (float)rows);
//    self.contentSize = CGSizeMake(5000, self.height);
}

#pragma mark - public

-(void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(infiniteScrollerItemsCount:)]) {
        itemsCount = [self.dataSource infiniteScrollerItemsCount:self];
        [items removeAllObjects];
        [self recalcCells];        
        for (int x = 0; x < rows * cols; x++) {
            [items addObject:[[InternalItem alloc] init]];
        }
        [self setNeedsLayout];
    }
}

-(UIView *)dequeueReusableView {
    UIView * obj = [reusableItems lastObject];
    if (obj) {
        [reusableItems removeLastObject];
    }
    return obj;
}

#pragma mark - set/getters

@end
