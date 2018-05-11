//
//  HexagonCalculator.m
//  testEndlessScroll
//
//  Created by Victor Zinets on 5/11/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

#import "HexagonCalculator.h"

#define sin60 0.8660254

@interface HexagonCalculator()
// "радиус"/пол-ширины одной соты
@property (nonatomic, readonly) CGFloat halfWidth;
// пол-высоты одной соты
@property (nonatomic, readonly) CGFloat halfHeight;
@end

@implementation HexagonCalculator

-(instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark setters/getters -

-(void)setCols:(NSInteger)cols {
    _cols = cols;
    [self calculateSizes];
}

-(NSInteger)rows {
    return (NSInteger)self.bounds.size.height / (2 * _halfHeight);
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
}

@end
