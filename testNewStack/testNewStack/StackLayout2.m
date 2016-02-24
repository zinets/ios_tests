//
//  StackLayout2.m
//  testNewStack
//
//  Created by Zinets Victor on 2/24/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackLayout2.h"

@implementation StackLayout2 {
    NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *attributes;
    UIPanGestureRecognizer *panRecognizer;
    
    // воображаемый сдвиг воображаемой ленты из ячеек
    CGPoint internalOffset, startPt;
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
        attr.frame = (CGRect){{15 + internalOffset.x, 40}, {290, 400}};
        [attributes setObject:attr forKey:idx];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return attributes.allValues;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {    
    return attributes[indexPath];
}

#pragma mark - recognizer

- (void)onPanRecognized:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender locationInView:self.collectionView];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            startPt = pt;
            break;
        case UIGestureRecognizerStateChanged:
            internalOffset.x += pt.x - startPt.x;
            startPt = pt;
            
            [self invalidateLayout];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            internalOffset.x = 0;
            
            [self invalidateLayout];
            break;
        default:
            break;
    }
}

@end
