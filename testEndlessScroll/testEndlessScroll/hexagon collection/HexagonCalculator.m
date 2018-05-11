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
    NSMutableArray *_centers;
    NSArray *_sortedCenters;
}
// "радиус"/пол-ширины одной соты
@property (nonatomic, readonly) CGFloat halfWidth;
// пол-высоты одной соты
@property (nonatomic, readonly) CGFloat halfHeight;
// ячейки заполняют собой ширину полностью, а по высоте надо (?) выравнивать по центру
@property (nonatomic, readonly) CGFloat topOffset ; // == bottomOffset вообще говоря
@end

@implementation HexagonCalculator

-(instancetype)init {
    if (self = [super init]) {
        _centers = [NSMutableArray new];
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

- (CGSize)elementSize {
    return (CGSize){_halfWidth * 2, _halfHeight * 2};
}

- (NSArray *)centers {
    return _sortedCenters;
}

- (NSInteger)numberOfItems {
    return _centers.count;
}

- (NSInteger)proposedNumberOfColumnsFor:(NSInteger)numberOfElements {
    if (numberOfElements == 0) {
        // иди нах
        return 0;
    }
    CGFloat cellHeight = self.bounds.size.height / numberOfElements; // это диаметр ячейки при таком кол-ве элементов
    if (numberOfElements < 3) {
        return 1; // это выглядит красиво
    }
    // test for 2
    CGFloat expectedWidth = self.bounds.size.width / 3.5; // magic, see pics
    CGFloat expectedHeight = expectedWidth * sin60;
    CGFloat maxHeight = self.bounds.size.height / (numberOfElements + 1);
    if (maxHeight >= expectedHeight) {
        return 2;
    }

    // test for 3
    expectedWidth = self.bounds.size.width / 5;
    expectedHeight = expectedWidth * sin60;
    maxHeight = self.bounds.size.height / ceil(numberOfElements / 3) / 2;

    return 4;
}

#pragma mark internal -

- (void)calculateSizes {
    NSInteger halfRows;
    if (_cols == 1) {
        _halfWidth = self.bounds.size.width / 3;
    } else if (_cols % 2 != 0) {
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
    [_centers removeAllObjects];

    NSMutableArray *array = [NSMutableArray array];
    CGRect frame = (CGRect){{}, self.elementSize};
    CGRect contentFrame = CGRectZero;
    if (self.cols > 1) {
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
                    CGPoint centerOfElement = (CGPoint) {CGRectGetMidX(frame), CGRectGetMidY(frame)};
                    [array addObject:[NSValue valueWithCGPoint:centerOfElement]];

                    contentFrame = CGRectUnion(contentFrame, frame);
                }
            }
        }
    } else {
        // если вдруг 1 колонка - очевидно другой механизм распределения
        for (int y = 0; y < self.rows; y++) {
            frame.origin.x = 0;
            frame.origin.y = y * (2 * self.halfHeight);

            if (CGRectContainsRect(self.bounds, frame)) {
                CGPoint centerOfElement = (CGPoint) {CGRectGetMidX(self.bounds), CGRectGetMidY(frame)};
                [array addObject:[NSValue valueWithCGPoint:centerOfElement]];

                contentFrame = CGRectUnion(contentFrame, frame);
            }
        }
    }

    // если нужно выровнять по вертикали ячейки в фрейме..

    _topOffset = (self.bounds.size.height - contentFrame.size.height) / 2;
    [array enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL *stop) {
        CGPoint point = [obj CGPointValue];
        point.y += self.topOffset;
        [_centers addObject:[NSValue valueWithCGPoint:point]];
    }];
    [self sortFrames];
}

- (NSComparisonResult)compareDictances:(CGPoint)point1 point:(CGPoint)point2 center:(CGPoint)center {
    CGFloat xDist = (point1.x - center.x);
    CGFloat yDist = (point1.y - center.y);
    CGFloat distance1 = sqrt((xDist * xDist) + (yDist * yDist));

    xDist = (point2.x - center.x);
    yDist = (point2.y - center.y);
    CGFloat distance2 = sqrt((xDist * xDist) + (yDist * yDist));

    return distance1 <= distance2 ? NSOrderedAscending : NSOrderedDescending;
}

- (void)sortFrames {
    CGPoint center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};

    // do not sort
    _sortedCenters = _centers;
    return;
    _sortedCenters = [_centers sortedArrayUsingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        CGPoint pt1 = [obj1 CGPointValue];
        CGPoint pt2 = [obj2 CGPointValue];
        return [self compareDictances:pt1 point:pt2 center:center];
    }];
}

@end
