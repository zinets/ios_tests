//
//  StackLayout2.m
//  testNewStack
//
//  Created by Zinets Victor on 2/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackLayout2.h"

#define CELL_WIDTH 290.
#define CELL_INSET 15.

@implementation StackLayout2 {
    NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *attributes;
    UIPanGestureRecognizer *panRecognizer;
    
    // воображаемый сдвиг воображаемой ленты из ячеек
    CGPoint internalOffset, startPt, lastPt;
    // индекс верхнего в стопке элемента - связан с отступом как отступ/ширина элемента
    NSInteger internalIndex;
}

-(CGSize)collectionViewContentSize {
    return self.collectionView.bounds.size;
}

-(instancetype)init {
    if (self = [super init]) {
        attributes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)prepareForTransitionToLayout:(UICollectionViewLayout *)newLayout {
    [self.collectionView removeGestureRecognizer:panRecognizer];
}

- (void)prepareForTransitionFromLayout:(UICollectionViewLayout *)oldLayout {
    [self.collectionView addGestureRecognizer:panRecognizer];
}

-(void)prepareLayout {
    if (!panRecognizer) {
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanRecognized:)];
        [self.collectionView addGestureRecognizer:panRecognizer];
    }
    [attributes removeAllObjects];
    NSInteger numOfItems = [self.collectionView numberOfItemsInSection:0];
    for (int x = 0; x < numOfItems; x++) {
        NSIndexPath *idx = [NSIndexPath indexPathForItem:x inSection:0];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:idx];
        attr.frame = (CGRect){{CELL_INSET, 40}, {CELL_WIDTH, 415}};
        [self recalcAttributes:attr];
        [attributes setObject:attr forKey:idx];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return attributes.allValues;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {    
    return attributes[indexPath];
}

#pragma mark - int

- (NSInteger)currentIndex {
    NSInteger res = 0;
    NSInteger numberOItems = [self.collectionView numberOfItemsInSection:0];
    
    res = (-internalOffset.x + CELL_WIDTH / 2) / CELL_WIDTH;
    res = MIN(numberOItems - 1, MAX(0, res));
    
    return res;
}

- (CGAffineTransform)transformForDepth:(CGFloat)depth {
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (depth > 0) {
        static CGFloat const magicK = 0.35;
        static CGFloat const maxDepthHeight = 25; // макс сдвиг вверх ячейки
        CGFloat k = depth * magicK;
#warning привязать 415 к высоте коллекции
        CGFloat kh = magicK * 415 / 2; // компенсация сжатия для правильного сдвига вверх
        
        transform = CGAffineTransformTranslate(transform, 0, - depth * (maxDepthHeight + kh));
        k = 1 - k;
        transform = CGAffineTransformScale(transform, k, k);
    }
    return transform;
}

- (void)recalcAttributes:(UICollectionViewLayoutAttributes *)attr {
    NSInteger indexOfItem = attr.indexPath.item;
    NSInteger topIndex = -internalOffset.x / CELL_WIDTH;
    if (indexOfItem == topIndex) {              // самая верхняя ячейка в стопке
        CGPoint c = attr.center;
        CGFloat dx = - internalOffset.x - topIndex * CELL_WIDTH ;
        c.x -= dx;
        attr.transform = CGAffineTransformIdentity;
        attr.center = c;
        attr.zIndex = 100;
    } else if (indexOfItem < topIndex) {        // ячейки ЕЩЕ выше (смахнутые в сторону)
        CGPoint c = attr.center;
        c.x -= self.collectionView.bounds.size.width;
        attr.center = c;
        attr.alpha = 0;
        attr.transform = CGAffineTransformIdentity;
        attr.zIndex = 1000;
    } else if (indexOfItem > topIndex && indexOfItem < topIndex + 4) { // ячейки на экране, 4 шт
        CGFloat dx = - internalOffset.x - topIndex * CELL_WIDTH;
        CGFloat depth = 1/4 - MAX(0, MIN(1, dx / CELL_WIDTH)) / 4;
        depth += (indexOfItem - topIndex) / 4.0;

        attr.transform = [self transformForDepth:depth];
        attr.zIndex = 100 - indexOfItem;
    } else if (indexOfItem == topIndex + 4) {   // следующая ячейка после 4-х - невидимая в статике
        CGFloat dx = - internalOffset.x - topIndex * CELL_WIDTH;
        CGFloat depth = 1/4 - MAX(0, MIN(1, dx / CELL_WIDTH)) / 4;
        depth += (indexOfItem - topIndex) / 4.0;
        
        attr.transform = [self transformForDepth:depth];
        attr.zIndex = 100 - indexOfItem;
        attr.alpha = dx / CELL_WIDTH;
    } else  {           // все что ниже
        CGPoint c = attr.center;
        c.x -= self.collectionView.bounds.size.width;
        attr.center = c;
        attr.alpha = 0;
        attr.transform = CGAffineTransformIdentity;
        attr.zIndex = 0;
    }
}

#pragma mark - recognizer

- (void)onPanRecognized:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender locationInView:self.collectionView];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            lastPt = pt;
            startPt = internalOffset;
            break;
        case UIGestureRecognizerStateChanged:
            internalOffset.x += pt.x - lastPt.x;
            lastPt = pt;

//            [self invalidateLayout];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGPoint v = [sender velocityInView:sender.view];
            CGFloat timeToPredict = 0.1;
            CGFloat dx = timeToPredict * v.x;
            internalOffset.x += dx;
            
            NSInteger index = [self currentIndex];
            internalOffset.x = -index * CELL_WIDTH;
            
//            [self invalidateLayout];
        } break;
        default:
            break;
    }

    [self invalidateLayout];
}

@end
