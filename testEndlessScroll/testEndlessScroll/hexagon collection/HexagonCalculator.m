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
// но (!) если широкий невысокий фрейм? тогда надо выравнивать и по центру по горизонтали
@property (nonatomic, readonly) CGFloat leftOffset;
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

- (NSInteger)proposedNumberOfColumnsFor:(NSInteger)numberOfElements maxCountOfColumns:(NSInteger)maxCountOfColumns {
    NSInteger proposedCount = 0;
    if (numberOfElements == 0) {
        // иди нах
        return proposedCount;
    } else {
        proposedCount++;
    }

    CGFloat expectedHalfWidth, expectedHalfHeight, maxHeight;
    NSInteger numberOfElementsInCol;

    // test for 1
    expectedHalfWidth = [self widthForCols:1];
    expectedHalfHeight = expectedHalfWidth * sin60;
    maxHeight = 2 * expectedHalfHeight * numberOfElements;
    if (maxHeight < self.bounds.size.height || proposedCount == maxCountOfColumns) {
        return proposedCount;
    } else {
        proposedCount++;
    }

    // test for 2
    expectedHalfWidth = [self widthForCols:2];
    expectedHalfHeight = expectedHalfWidth * sin60;
    maxHeight = expectedHalfHeight * (numberOfElements + 1); // при 2х столбиках кол-во полувышин всегда на 1 больше кол-ва элементов
    if (maxHeight < self.bounds.size.height || proposedCount == maxCountOfColumns) {
        return proposedCount;
    } else {
        proposedCount++;
    }

    // test for 3
    expectedHalfWidth = [self widthForCols:3];
    expectedHalfHeight = expectedHalfWidth * sin60;
    numberOfElementsInCol = (int)ceil(numberOfElements / 3.) * 2 + (numberOfElements % 3 == 1 ? 0 : 1);
    maxHeight = numberOfElementsInCol * expectedHalfHeight;
    if (maxHeight < self.bounds.size.height || proposedCount == maxCountOfColumns) {
        return proposedCount;
    } else {
        proposedCount++;
    }

    // test for 4
    expectedHalfWidth = [self widthForCols:4];
    expectedHalfHeight = expectedHalfWidth * sin60;
    numberOfElementsInCol = (int)ceil(numberOfElements / 4.) * 2 + (numberOfElements % 4 > 2 ? 1 : 0);
    maxHeight = numberOfElementsInCol * expectedHalfHeight;
    if (maxHeight < self.bounds.size.height || proposedCount == maxCountOfColumns) {
        return proposedCount;
    } else {
        proposedCount++;
    }

    return proposedCount;
}

#pragma mark internal -

- (CGFloat)widthForCols:(NSInteger)columns {
    switch (columns) {
        case 1:
            return MIN(self.bounds.size.width, self.bounds.size.height) / 3;
        case 2:
            return MIN(self.bounds.size.width, self.bounds.size.height) / 3.5;
        case 3:
            return MIN(self.bounds.size.width, self.bounds.size.height) / 5;
        case 4:
            return MIN(self.bounds.size.width, self.bounds.size.height) / 6.5;
        case 5:
            return MIN(self.bounds.size.width, self.bounds.size.height) / 8;
        default:
            return 0;
    }

}

- (void)calculateSizes {
    if (_cols > 0) {
        NSInteger halfRows;
        _halfWidth = [self widthForCols:_cols];
        _halfHeight = _halfWidth * sin60;

        [self calculateFrames];
    }
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
                if (y % 2 != 0) {
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

    // если нужно выровнять ячейки в фрейме..
    _topOffset = (self.bounds.size.height - contentFrame.size.height) / 2;
    _leftOffset = (self.bounds.size.width - contentFrame.size.width) / 2;
    if (_cols == 1) {
        _leftOffset = 0;
    }
    [array enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL *stop) {
        CGPoint point = [obj CGPointValue];
        point.x += self.leftOffset;
        point.y += self.topOffset;

        [_centers addObject:[NSValue valueWithCGPoint:point]];
    }];
    [self sortFrames];
}

- (NSComparisonResult)compareDictances:(CGPoint)point1 point:(CGPoint)point2 center:(CGPoint)center {
//    CGFloat xDist = (point1.x - center.x);
//    CGFloat yDist = (point1.y - center.y);
//    CGFloat distance1 = sqrt((xDist * xDist) + (yDist * yDist));
//
//    xDist = (point2.x - center.x);
//    yDist = (point2.y - center.y);
//    CGFloat distance2 = sqrt((xDist * xDist) + (yDist * yDist));

//    return distance1 <= distance2 ? NSOrderedAscending : NSOrderedDescending;

    // вариант раскладки - ближе к верху 9а не вокруг центра)
    return point1.y < point2.y ? NSOrderedAscending : NSOrderedDescending;
}

- (void)sortFrames {
    CGPoint center = (CGPoint){self.bounds.size.width / 2, self.bounds.size.height / 2};

    // do not sort
//    _sortedCenters = _centers;
//    return;
    _sortedCenters = [_centers sortedArrayUsingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
        CGPoint pt1 = [obj1 CGPointValue];
        CGPoint pt2 = [obj2 CGPointValue];
        return [self compareDictances:pt1 point:pt2 center:center];
    }];
}

@end
