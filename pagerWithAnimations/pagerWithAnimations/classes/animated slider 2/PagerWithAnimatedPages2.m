//
// Created by Victor Zinets on 5/2/18.
// Copyright (c) 2018 Victor Zinets. All rights reserved.
//

#import "PagerWithAnimatedPages2.h"
#import "PagerItem.h"
#import "PagerAnimatedPage.h"


@implementation PagerWithAnimatedPages2 {
    NSMutableArray <PagerAnimatedPage *> *views;
    NSTimer *slideTimer;
}

CGFloat const pageIndicatorHeight2 = 10;
CGFloat const timerInterval2 = 3;

- (void)commonInit {
    views = [NSMutableArray new];
    [self addSubview:self.pageIndicator];

    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeftRecognizer];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipeRightRecognizer];

    [self startAnimating];
}

- (void)onSwipe:(UISwipeGestureRecognizer *)sender {
    if ((sender.direction & UISwipeGestureRecognizerDirectionLeft) == UISwipeGestureRecognizerDirectionLeft) {
        self.currentPage++;
    } else if ((sender.direction & UISwipeGestureRecognizerDirectionRight) == UISwipeGestureRecognizerDirectionRight) {
        self.currentPage--;
    }
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

#pragma mark getters -

-(HorizontalPageIndicator *)pageIndicator {
    if (!_pageIndicator) {
        CGRect frm = self.bounds;
        frm.origin.y = frm.size.height - pageIndicatorHeight2;
        frm.size.height = pageIndicatorHeight2;

        _pageIndicator = [[HorizontalPageIndicator alloc] initWithFrame:frm];
        _pageIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _pageIndicator.backgroundColor = [UIColor clearColor];
        _pageIndicator.spacing = 8; {
            UIView *mark = [[UIView alloc] initWithFrame:(CGRect){0, 0, 6, 6}];
            mark.layer.cornerRadius = 3;
#warning // todo colors of hor.scroll indicator
            //            mark.backgroundColor = [UIColor colorWithHex:Aprnc.kPPPageMarkSelected];
            _pageIndicator.selectedMarkView = mark;

            mark = [[UIView alloc] initWithFrame:(CGRect){0, 0, 6, 6}];
            mark.layer.cornerRadius = 3;
            //            mark.backgroundColor = [UIColor colorWithHex:Aprnc.kPPPageMark];
            _pageIndicator.inactiveMarkView = mark;
        }
    }
    return _pageIndicator;
}

- (void)setDataSource:(NSArray <PagerItem *> *)dataSource {
    [views enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [views removeAllObjects];

    for (int x = 0; x < dataSource.count; x++) {
        PagerItem *item = dataSource[x];

        PagerAnimatedPage *view = [[PagerAnimatedPage alloc] initWithFrame:self.bounds];
        view.titleText = item.itemTitle;
        view.descriptionText = item.itemDescription;

        if (x > 0) {
            [view removeToLeft];
        }

        [views addObject:view];
        [self insertSubview:view atIndex:0];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage != currentPage) {
        if (currentPage < 0) {
            [views[_currentPage] removeToRight];
            _currentPage = views.count - 1;
            [views[_currentPage] addFromLeft];
        } else if (currentPage >= views.count) {
            [views[_currentPage] removeToLeft];
            _currentPage = 0;
            [views[_currentPage] addFromRight];
        } else if (_currentPage < currentPage) {
            [views[_currentPage] removeToLeft];
            _currentPage = currentPage;
            [views[_currentPage] addFromRight];
        } else {
            [views[_currentPage] removeToRight];
            _currentPage = currentPage;
            [views[_currentPage] addFromLeft];
        }

        self.pageIndicator.currentPage = _currentPage;
        [self startAnimating];
    }
}

#pragma mark animation -

- (void)startAnimating {
    [self stopAnimating];

    slideTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval2 target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
}

- (void)stopAnimating {
    [slideTimer invalidate];
}

- (void)onTimer:(id)timer {
    self.currentPage++;
}
@end