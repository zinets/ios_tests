//
//  LVHPhotoScrollView.m
//  Flirt
//
//  Created by Zinets Victor on 4/17/15.
//  Copyright (c) 2015 Yarra. All rights reserved.
//

#import "PhotoScrollerView.h"

@interface PhotoScrollerView () <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    NSMutableArray * reusePool;
    // после каждого reload в этом массиве хранятс координаты вью - потому что иначе (учитывая, что размер вью может быть разным, между вью могут быть "зазоры") простой арифметикой нельзя узнать соотв. точки в скроллере и вью под этой точкой
    NSMutableArray *frames;
    BOOL _intPagingEnabled;
    UIPanGestureRecognizer *pullDownGestureRecognizer;
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
        self.scrollsToTop = NO;
        
        visiblePhotos = [NSMutableDictionary dictionaryWithCapacity:3];
        reusePool = [NSMutableArray arrayWithCapacity:5];
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        _tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:_tapRecognizer];
        
        self.pullDownLimit = 0;
    }
    return self;
}

#pragma mark - internal

- (void)onTap:(UITapGestureRecognizer *)sender {
    if ([self.photoScrollerDelegate respondsToSelector:@selector(scroller:didSelectPhoto:)]) {
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
            [self.photoScrollerDelegate scroller:self didSelectPhoto:photoIndex];
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
    NSInteger retVal = [self indexForPoint:self.contentOffset];
    return retVal;
}

-(void)setCurrentPhotoIndex:(NSInteger)currentPhotoIndex {
    // опять же это "наивная" реализация, НЕ учитывающая а) spacing между вью и б) разные размеры вью
    CGPoint pt = {};
    if (self.verticalScrolling) {
        pt.y = currentPhotoIndex * self.bounds.size.height;
    } else {
        pt.x = currentPhotoIndex * self.bounds.size.width;
    }
    self.contentOffset = pt;
    if ([self.photoScrollerDelegate respondsToSelector:@selector(scroller:photoIndexChanged:)]) {
        [self.photoScrollerDelegate scroller:self photoIndexChanged:currentPhotoIndex];
    }
}

- (void)reset {
    self.contentOffset = CGPointZero;
    [self reloadPhotos];
}

-(void)reloadPhotos
{
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
    // вот у нас бага - если у юзера нет фоток и скроллер занимает бОльшую часть ячейки - по тапе по скроллеру (этому) ничего не произойдет; поэтому я настрою пропускание евентов дальше вниз для "пустого" скроллера
    self.userInteractionEnabled = nums > 0;
    
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
    NSInteger photoIndex;
    if (self.verticalScrolling) {
        photoIndex = self.contentOffset.y / self.bounds.size.height;
    } else {
        photoIndex = self.contentOffset.x / self.bounds.size.width;
    }
    [self setCurrentPhotoIndex:photoIndex];
}

- (UIView *)dequeueView
{
    UIView * view = nil;
    if (reusePool.count > 0) {
        view = [reusePool firstObject];
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

-(void)setPullDownLimit:(CGFloat)pullDownLimit {
    if (_pullDownLimit != pullDownLimit) {
        _pullDownLimit = pullDownLimit;
        
        if (_pullDownLimit == 0) {
            if (pullDownGestureRecognizer != nil) {
                [self removeGestureRecognizer:pullDownGestureRecognizer];
            }
        } else {
            pullDownGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
            pullDownGestureRecognizer.delegate = self;
            pullDownGestureRecognizer.delaysTouchesBegan = YES;
            [self addGestureRecognizer:pullDownGestureRecognizer];
        }
    }
}

#pragma mark - сам себе делегат

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self arrangePhotos];
    if ([self.photoScrollerDelegate respondsToSelector:@selector(scroller:photoIndexChanged:)]) {
        NSInteger photoIndex = [self indexForPoint:scrollView.contentOffset];
        [self.photoScrollerDelegate scroller:self photoIndexChanged:photoIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pullDownGestureRecognizer.enabled = YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pullDownGestureRecognizer.enabled = NO;
    if ([self.photoScrollerDelegate respondsToSelector:@selector(photoIndexWillChange:)]) {
        NSInteger photoIndex = [self indexForPoint:scrollView.contentOffset];
        [self.photoScrollerDelegate photoIndexWillChange:photoIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
#define MAX_SHIFT_VALUE_FOR_SHOW_PHOTOS 70.0f
    if ([self.photoScrollerDelegate respondsToSelector:@selector(scrollerWasOverscrolled:)]) {
        CGFloat shift = scrollView.contentOffset.x - (scrollView.contentSize.width - scrollView.bounds.size.width);
        if (shift >= MAX_SHIFT_VALUE_FOR_SHOW_PHOTOS) {
            [self.photoScrollerDelegate scrollerWasOverscrolled:self];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (_intPagingEnabled) {
        if (self.verticalScrolling) {
            CGFloat centeredYOffsetAfterStop = targetContentOffset->y + scrollView.bounds.size.height / 2;
            CGPoint pt = (CGPoint){scrollView.bounds.size.width / 2, centeredYOffsetAfterStop};
            
            for (int x = 0; x < frames.count; x++) {
                CGRect frm = [frames[x] CGRectValue];
                if (CGRectContainsPoint(frm, pt)) {
                    if (x == 0) {
                        targetContentOffset->y = 0;
                    } else if (x == frames.count - 1) {
                        targetContentOffset->y = scrollView.contentSize.height - scrollView.bounds.size.height;
                    } else {
                        targetContentOffset->y = frm.origin.y + frm.size.height / 2 - scrollView.bounds.size.height / 2;
                    }
                    
                    break;
                }
            }
        } else {
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
}

-(UIView *)currentView {
    NSInteger index = [self currentPhotoIndex];
    return visiblePhotos[@(index)];
}

- (void)onPanGesture:(UIPanGestureRecognizer *)sender {
    
    static CGPoint startPt = {};
    static UIScrollView *view = nil; // мне не принципно знать что внутри за вью - НО это должно быть что-то из скроллеров
    // можно конечно проверять тип, но - проще задавать в нужных случаях pullDownLimit
    // так что если начнет тут где-то падать - может придется добавить проверку на тип :)
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            startPt = [sender locationInView:self];
            view = (id)[self currentView];
            
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint pt = [sender locationInView:self];
            CGFloat offset = MAX(0, pt.y - startPt.y);
            CGFloat xOffset = MAX(0, pt.x - startPt.x);
            if (offset > xOffset && view.zoomScale == view.minimumZoomScale) {
                self.panGestureRecognizer.enabled = NO;
                
                if ([self.photoScrollerDelegate respondsToSelector:@selector(scroller:wasPulledDownBy:)]) {
                    CGFloat pullValue = MIN(1, offset / self.pullDownLimit);
                    [self.photoScrollerDelegate scroller:self wasPulledDownBy:pullValue];
                }
                
                CGAffineTransform transform = CGAffineTransformMakeTranslation(0, offset);
                view.transform = transform;
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            if (view.zoomScale == view.minimumZoomScale) {
                [UIView animateWithDuration:0.25 animations:^{
                    if ([self.photoScrollerDelegate respondsToSelector:@selector(scroller:wasPulledDownBy:)]) {
                        [self.photoScrollerDelegate scroller:self wasPulledDownBy:0];
                    }
                    view.transform = CGAffineTransformIdentity;
                    
                    // можно начать выход из фулцкрина еще до окончания оттяжки..
                    CGPoint pt = [sender locationInView:self];
                    CGFloat offset = MAX(0, pt.y - startPt.y);
                    if (offset > self.pullDownLimit && [self.photoScrollerDelegate respondsToSelector:@selector(scrollerDetectedPullDown:)]) {
                        [self.photoScrollerDelegate scrollerDetectedPullDown:self];
                    }
                } completion:^(BOOL finished) {
                    // если скрол был запрещен, то самое время его снова разрешить
                    self.panGestureRecognizer.enabled = YES;
                    // .. а можно дождаться возврата оттяжки и потом выйти из фулцкрина
//                    CGPoint pt = [sender locationInView:self];
//                    CGFloat offset = MAX(0, pt.y - startPt.y);
//                    if (offset > self.pullDownLimit && [self.dataSource respondsToSelector:@selector(scrollerDetectedPullDown:)]) {
//                        [self.dataSource scrollerDetectedPullDown:self];
//                    }
                }];
            }
        } break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL res = NO;
    if ([gestureRecognizer isEqual:pullDownGestureRecognizer] &&
        [otherGestureRecognizer isEqual:self.panGestureRecognizer]) {
        res = YES;
    }
    return res;
}

#pragma mark - fixes for scrolling

// для контент-оффсета определяю номер подходящего вью
- (NSInteger)indexForPoint:(CGPoint)pt {
    __block NSInteger res = NSNotFound;
    if (self.verticalScrolling) {
        pt.y += self.bounds.size.height / 2;
    } else {
        pt.x += self.bounds.size.width / 2;
    }
    [frames enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frm = [obj CGRectValue];
        if (CGRectContainsPoint(frm, pt)) {
            res = idx;
            *stop = YES;
        }
    }];
    return res;
}

@end
