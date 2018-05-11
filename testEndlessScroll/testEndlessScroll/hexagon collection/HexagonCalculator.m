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
    return self.bounds.size.height / _halfHeight - 1;
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
    CGRect frame;
    for (int y = 0; y < self.rows; y++) {
        for (int x = 0; x < self.cols; x++) {
            CGFloat top = y * self.halfHeight;
            CGFloat left = x * 3 * self.halfWidth;
            frame = (CGRect){{left, top}, frameSize};
            
            [_frames addObject:[NSValue valueWithCGRect:frame]];
        }
    }
}

@end
