//
//  HexagonCalculator.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/11/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "HexagonCalculator.h"

#define sin60 0.8660254

@interface HexagonCalculator() {
    NSMutableArray *_frames;
}
// "радиус"/пол-ширины одной соты
@property (nonatomic, readonly) CGFloat halfWidth;
// пол-высоты одной соты
@property (nonatomic, readonly) CGFloat halfHeight;
@end

@implementation HexagonCalculator

-(instancetype)init {
    if (self = [super init]) {
        _frames = [NSMutableArray new];
    }
    return self;
}

#pragma mark setters/getters -

-(void)setCols:(NSInteger)cols {
    _cols = cols;
    [self calculateSizes];
}

-(NSInteger)rows {
    return (NSInteger) (self.bounds.size.height / _halfHeight - 1);
}

-(void)setBounds:(CGRect)bounds {
    _bounds = bounds;
    [self calculateSizes];
}

#pragma mark internal -

- (void)calculateSizes {
    NSInteger halfRows;
    if (_cols % 2 != 0) {
        halfRows = _cols / 2 * 3 + 2;
        _halfWidth = self.bounds.size.width / halfRows;
    } else {
        halfRows = _cols / 2 * 3;
        _halfWidth = self.bounds.size.width / (halfRows + 0.5);
    }
    _halfHeight = _halfWidth * sin60;
    
    [self calculateFrames];
}

-(void)calculateFrames {
    [_frames removeAllObjects];
    
    CGSize frameSize = (CGSize){self.halfWidth * 2, self.halfHeight * 2};
    CGRect frame = (CGRect){{}, frameSize};
    for (int y = 0; y < self.rows; y++) {
        for (int x = 0; x < self.cols / 2 + 1; x++) {
            frame.origin.y = y * self.halfHeight;
            frame.origin.x = x * 3 * self.halfWidth;
            // заполнять из самого угла или как в картинке в дизе (там первая ячейка смещена вправо на пол-ячейки, а след. ряд начинается с самого начала)
            // y % 2 == 0 - будет как в дизе, y % 2 != 0 - первая ячейка - в углу
            if (y % 2 == 0) {
                frame.origin.x += 1.5 * self.halfWidth;
            }
            if (CGRectContainsRect(self.bounds, frame)) {
                [_frames addObject:[NSValue valueWithCGRect:frame]];
            }
        }
    }
}

@end
