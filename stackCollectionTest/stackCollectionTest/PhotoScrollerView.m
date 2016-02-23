//
//  LVHPhotoScrollView.m
//  Flirt
//
//  Created by Zinets Victor on 4/17/15.
//  Copyright (c) 2015 Yarra. All rights reserved.
//

#import "PhotoScrollerView.h"
#import "UIColor+MUIColor.h"

@interface PhotoScrollerView () <UIScrollViewDelegate> {
    NSMutableArray * reusePool;
    NSMutableDictionary * visiblePhotos;
    // после каждого reload в этом массиве хранятс координаты вью - потому что иначе (учитывая, что размер вью может быть разным, между вью могут быть "зазоры") простой арифметикой нельзя узнать соотв. точки в скроллере и вью под этой точкой
    NSMutableArray *frames;
    BOOL _intPagingEnabled;
}

@end

@implementation PhotoScrollerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        
        visiblePhotos = [NSMutableDictionary dictionaryWithCapacity:3];
        reusePool = [NSMutableArray arrayWithCapacity:5];
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        _tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:_tapRecognizer];
    }
    return self;
}

#pragma mark - internal

- (void)onTap:(UITapGestureRecognizer *)sender {
    if ([self.dataSource respondsToSelector:@selector(scroller:didSelectPhoto:)]) {
        __block NSInteger photoIndex = NSNotFound;
        __block CGPoint pt = [sender locationInView:self];
        [frames enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frm = [obj CGRectValue];
            if (CGRectContainsPoint(frm, pt)) {
                photoIndex = idx;
                *stop = YES;
            }
        }];
        if (photoIndex != NSNotFound) {
            [self.dataSource scroller:self didSelectPhoto:photoIndex];
        }
    }
}

- (void)arrangePhotos {
    if (frames.count > 0) {
        [self.placeholder removeFromSuperview];
        for (int x = 0; x < frames.count; x++) {
            CGRect frm = [frames[x] CGRectValue];
            if (CGRectIntersectsRect(frm, self.bounds)) {
                UIView * view = visiblePhotos[@(x)];
                if (!view) {
                    view = [self.dataSource scroller:self viewForIndex:x];
                    [self addSubview:view];
                    [visiblePhotos setObject:view forKey:@(x)];
                    view.frame = frm;
                }                
            } else {
                UIView * view = visiblePhotos[@(x)];
                if (view) {
                    [view removeFromSuperview];
                    [visiblePhotos removeObjectForKey:@(x)];
                    [reusePool addObject:view];
                }
            }
        }
    } else {
        self.placeholder.center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};
        [self addSubview:self.placeholder];
    }
}

-(void)setPagingEnabled:(BOOL)pagingEnabled {
    [super setPagingEnabled:NO];
    _intPagingEnabled = pagingEnabled; // по идеальному тут надо передернуть оффсет, если включаем пажинг - но пофиг
}

#pragma mark - public

- (NSInteger)currentPhotoIndex {
    NSInteger retVal = -1;
//#warning здесь тоже определение текущего вью сломано
	// имеется ввиду что неправильно будет определять номер видимой фотки ( например 1/10)
	// сломано в IWU но сейчас там нет номера фотки по дизайну
    NSInteger nums = [self.dataSource numberOfPhotos];
    if (nums > 0) {
        NSInteger integerVal = self.contentOffset.x + (self.bounds.size.width / 2);
        if (integerVal > 0) {
            retVal = integerVal / ((NSInteger)self.bounds.size.width);
        }
    }
    
    return retVal;
}

- (void)reset {
    self.contentOffset = CGPointZero;
    [self reloadPhotos];
}

- (void)reloadPhotos {
    [visiblePhotos.allValues enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
        [reusePool addObject:obj];
    }];
    [visiblePhotos removeAllObjects];
    
    NSInteger nums = [self.dataSource numberOfPhotos];
    if (nums > 0) {
        frames = [NSMutableArray arrayWithCapacity:nums];
        
        CGSize contentSize = (CGSize){0, self.bounds.size.height};
        if (self.verticalScrolling) {
            contentSize = (CGSize){self.bounds.size.width, 0};
        }
        for (int x = 0; x < nums; x++) {
            CGFloat space = 0;
            if (x > 0 && [self.dataSource respondsToSelector:@selector(spaceBetweenViews:)]) {
                space = [self.dataSource spaceBetweenViews:self];
            }
            CGSize sz;
            if ([self.dataSource respondsToSelector:@selector(scroller:sizeForViewWithIndex:)]) {
                sz = [self.dataSource scroller:self sizeForViewWithIndex:x];
            } else {
                sz = self.bounds.size;
            }
            CGPoint pt = (CGPoint){contentSize.width + space, 0};
            if (self.verticalScrolling) {
                pt = (CGPoint){0, contentSize.height + space};
            }
            CGRect frm = (CGRect){pt, sz};
            [frames addObject:[NSValue valueWithCGRect:frm]];
            if (self.verticalScrolling) {
                contentSize.height += space + sz.height;
            } else {
                contentSize.width += space + sz.width;
            }
        }
        self.contentSize = contentSize;
    } else {
        frames = nil;
        self.contentSize = self.bounds.size;
    }
    
    [self arrangePhotos];
    if (self.verticalScrolling) {
        if (self.contentOffset.y >= self.contentSize.height) {
            self.contentOffset = CGPointZero;
        }
    } else {
        if (self.contentOffset.x >= self.contentSize.width) {
            self.contentOffset = CGPointZero;
        }
    }
    if ([self.dataSource respondsToSelector:@selector(photoIndexChanged:)]) {
        NSInteger photoIndex = self.contentOffset.x / self.bounds.size.width;
        if (self.verticalScrolling) {
            photoIndex = self.contentOffset.y / self.bounds.size.height;
        }
        [self.dataSource photoIndexChanged:photoIndex];
    }
}

- (UIView *)dequeueView
{
    UIView * view = nil;
    if (reusePool.count > 0) {
        view = [reusePool lastObject];
        [reusePool removeObject:view];
    }
    return view;
}

-(void)setPlaceholder:(UIView *)placeholder {
    if (_placeholder) {
        [_placeholder removeFromSuperview];
    }
    _placeholder = placeholder;
}

-(void)setVerticalScrolling:(BOOL)verticalScrolling {
    if (verticalScrolling != _verticalScrolling) {
        _verticalScrolling = verticalScrolling;
        [self reloadPhotos];
    }
}

#pragma mark - сам себе делегат

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self arrangePhotos];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.dataSource respondsToSelector:@selector(photoIndexChanged:)]) {
        NSInteger photoIndex = scrollView.contentOffset.x / self.bounds.size.width;
        [self.dataSource photoIndexChanged:photoIndex];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.dataSource respondsToSelector:@selector(photoIndexWillChange:)]) {
        NSInteger photoIndex = scrollView.contentOffset.x / self.bounds.size.width;
        [self.dataSource photoIndexWillChange:photoIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
#define MAX_SHIFT_VALUE_FOR_SHOW_PHOTOS 70.0f
    CGFloat shift = scrollView.contentOffset.x - (scrollView.contentSize.width - scrollView.bounds.size.width);
    if (shift >= MAX_SHIFT_VALUE_FOR_SHOW_PHOTOS &&
        [self.dataSource respondsToSelector:@selector(scrollerWasOverscrolled:)]) {
        [self.dataSource scrollerWasOverscrolled:self];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_intPagingEnabled) {
        CGFloat centeredXOffsetAfterStop = targetContentOffset->x + scrollView.bounds.size.width / 2;
        CGPoint pt = (CGPoint){centeredXOffsetAfterStop, scrollView.bounds.size.height / 2};
        
        for (int x = 0; x < frames.count; x++) {
            CGRect frm = [frames[x] CGRectValue];
            if (CGRectContainsPoint(frm, pt)) {
                if (x == 0) {
                    targetContentOffset->x = 0;
                } else if (x == frames.count - 1) {
                    targetContentOffset->x = scrollView.contentSize.width - scrollView.bounds.size.width;
                } else {
                    targetContentOffset->x = frm.origin.x + frm.size.width / 2 - scrollView.bounds.size.width / 2;
                }
                
                break;
            }
        }
    }
}


@end
