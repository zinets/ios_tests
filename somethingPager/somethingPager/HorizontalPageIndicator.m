//
//  FlirtPageIndicator.m
//  Flirt
//
//  Created by Zinetz Victor on 09.09.13.
//  Copyright (c) 2013 Yarra. All rights reserved.
//

#import "HorizontalPageIndicator.h"

@implementation HorizontalPageIndicator {
    CGPoint cornerPoint;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    _spacing = 10;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)calcCornerPoint {
    CGFloat y = 0;
    CGFloat x = 0;
    if (_edgeAlignment) {
        x = 0;
        y = 0;
    } else {
        if (_vertical) {
            x = (self.frame.size.width - _inactiveMark.size.width) / 2;
            y = (self.frame.size.height - _numberOfPages * _inactiveMark.size.height - (_numberOfPages - 1) * self.spacing) / 2;
        } else {
            y = (self.frame.size.height - _inactiveMark.size.height) / 2;
            x = (self.frame.size.width - _numberOfPages * _inactiveMark.size.width - (_numberOfPages - 1) * self.spacing) / 2;
        }
    }
    cornerPoint = CGPointMake(x, y);
}

- (void)setSelectedMarkView:(UIView *)selectedMarkView {
    self.selectedMark = [self imageFromView:selectedMarkView];
}

- (void)setInactiveMarkView:(UIView *)inactiveMarkView {
    self.inactiveMark = [self imageFromView:inactiveMarkView];
}

-(void)setSelectedMark:(UIImage *)selectedMark {
    _selectedMark = selectedMark;
    [self setNeedsDisplay];
}

-(void)setInactiveMark:(UIImage *)inactiveMark {
    _inactiveMark = inactiveMark;
    [self calcCornerPoint];
    [self setNeedsDisplay];
}

-(void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self calcCornerPoint];
    [self setNeedsDisplay];
}

-(void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = MAX(0, MIN(currentPage, self.numberOfPages));
    [self setNeedsDisplay];
}

- (void)setVertical:(BOOL)vertical {
    _vertical = vertical;
    [self setNeedsDisplay];
}

- (void)setEdgeAlignment:(BOOL)edgeAlignment {
    _edgeAlignment = edgeAlignment;
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calcCornerPoint];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    if (_numberOfPages == 0) return;
    CGPoint p = cornerPoint;
    for (int idx = 0; idx < _numberOfPages; idx++) {
        if ((idx == _numberOfPages - 1) && (_lastInactiveMark)) {
            // если последнюю иконку надо рисовать другую, то ...
            if (idx == _currentPage) {
                [_lastSelectedMark drawAtPoint:p];
            } else {
                [_lastInactiveMark drawAtPoint:p];
            }
        } else {
            // как раньше
            if (idx == _currentPage) {
                [_selectedMark drawAtPoint:p];
            } else {
                [_inactiveMark drawAtPoint:p];
            }
        }

        if (self.vertical) {
            // в ffi отступы эти не нужны, пока так, потом переделаем на проперть отcтуп
            p.y += _inactiveMark.size.height;
        } else {
            p.x += _inactiveMark.size.width + self.spacing;
        }
    }
}

- (void)setLastInactiveMark:(UIImage *)lastInactiveMark {
    _lastInactiveMark = lastInactiveMark;
    [self calcCornerPoint];
    [self setNeedsDisplay];
}

- (void)setLastSelectedMark:(UIImage *)lastSelectedMark {
    _lastSelectedMark = lastSelectedMark;
    [self setNeedsDisplay];
}

-(void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self setNeedsDisplay];
}

-(void)sizeToFit {
    if (self.vertical) {
        // вертикал == FFI - а там какие-то туду вон выше по коментах - делать ничего не буду
    } else {
        CGSize sz = _inactiveMark.size;
        sz.width = sz.width * self.numberOfPages + self.spacing * (self.numberOfPages - 1);
        
        self.frame = (CGRect){self.frame.origin, sz};
    }
    [self setNeedsDisplay];
}


#pragma mark - 
- (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

@end
