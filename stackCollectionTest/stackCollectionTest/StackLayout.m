//
//  StackLayout.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/12/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackLayout.h"
#import "StackCellAttributes.h"
#import "UIView+Geometry.h"

@implementation StackLayout {
    NSMutableDictionary <NSIndexPath *, UICollectionViewLayoutAttributes *> *attributes;
    
    UIPanGestureRecognizer *panRecognizer;
    CGPoint startPt, startCenter;
}

#pragma mark - overload

-(CGSize)collectionViewContentSize {
    CGSize sz = self.collectionView.bounds.size;
    sz.width -= self.collectionView.contentInset.left + self.collectionView.contentInset.right;
    sz.height -= self.collectionView.contentInset.top + self.collectionView.contentInset.bottom;
    return sz;
}

-(void)prepareLayout {
    [super prepareLayout];
    if (!attributes) {
        attributes = [NSMutableDictionary dictionary];
    
        [self fillAttributes];
    }
    
    if (!panRecognizer) {
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanRecognized:)];
        [self.collectionView addGestureRecognizer:panRecognizer];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *> *res = [NSMutableArray array];
    for (int x = 0; x < [self.collectionView numberOfItemsInSection:0]; x++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:x inSection:0]];
        [res addObject:attr];
    }
    return res;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = attributes[indexPath];
    return attr;
}

#pragma mark - internal

//+ (Class)layoutAttributesClass {
//    return [StackCellAttributes class];
//}

- (void)fillAttributes {
    CGFloat const transformKoef = 0.07;
    CGFloat const height = 415.0;
    CGFloat const vert_spacing = 7;
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    for (int x = 0; x < numberOfItems; x++) {
        NSIndexPath *idx = [NSIndexPath indexPathForItem:x inSection:0];
        UICollectionViewLayoutAttributes *attr = attributes[idx];
        if (!attr) {
            attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:idx];
        }
        switch (x) {
            case 0:
                attr.frame = (CGRect){{320, 30}, {290, height}};
                attr.alpha = 1;
                attr.transform3D = CATransform3DIdentity;
                attr.zIndex = 100 - x;
                break;

            case 1:
                attr.frame = (CGRect){{15, 30}, {290, height}};
                attr.alpha = 1;
                attr.transform3D = CATransform3DIdentity;
                attr.zIndex = 100 - x;
                break;
            case 4:
                attr.frame = (CGRect){{15, 30}, {290, height}};
                attr.alpha = 0.;
                attr.transform3D = CATransform3DMakeScale(1 - transformKoef * x, 1 - transformKoef * x, 1);
                attr.zIndex = 10 - x;
                break;
            default: {
                attr.frame = (CGRect){{15, 30}, {290, height}};
                attr.alpha = 1 - x * 0.1;
                
                CGFloat k = 1 - transformKoef * x;
                CATransform3D transform = CATransform3DIdentity;
                
                CGFloat dh = (height - k * height) / 2 + (vert_spacing * x) / k;
                transform = CATransform3DTranslate(transform, 0, - dh, 0);
                transform = CATransform3DScale(transform, k, k, 1);
                attr.transform3D = transform;
                attr.zIndex = 10 - x;
                
            } break;
        }
        [attributes setObject:attr forKey:idx];
    }
}

#pragma mark - gestures

- (void)onPanRecognized:(UIPanGestureRecognizer *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewCell *topCell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attr = attributes[indexPath];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            startPt = [sender locationInView:self.collectionView];
            startCenter = topCell.center;
            
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint pt = [sender locationInView:self.collectionView];
            CGFloat delta = pt.x - startPt.x;
            if (!self.canPan && delta < 0) {
//                delta = 0;
            }
            CGPoint center = startCenter;
            center.x += delta;
//            topCell.center = center;
//            attr.center = center;
            CGFloat angle = delta * M_PI / 500;
            CATransform3D transform = CATransform3DIdentity;
//            transform = CATransform3DRotate(transform, angle, 0, 1, 0);;
            transform = CATransform3DTranslate(transform, delta, 0, 200);
            attr.transform3D = transform;
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGPoint pt = [sender locationInView:self.collectionView];
            CGFloat delta = pt.x - startPt.x;
            if (!self.canPan && delta < 0) {
//                delta = 0;
            }
            
            CGPoint center = startCenter;
            center.x += delta;
#warning инерцию
            if (CGRectContainsPoint(self.collectionView.bounds, center)) {
                [UIView animateWithDuration:0.25 animations:^{
//                    topCell.center = startCenter;
                    
                    attr.transform3D = CATransform3DIdentity;
                }];
            } else {
                CGPoint v = [sender velocityInView:sender.view];
                if (v.x > 0) {
//                    a.x += 100;
//                } else {
//                    center.x -= 100;
                    attr.transform3D = CATransform3DTranslate(attr.transform3D, 100, 0, 0);
                } else {
                    attr.transform3D = CATransform3DTranslate(attr.transform3D, -100, 0, 0);
                }
                
//                [UIView animateWithDuration:0.25 animations:^{
//                    topCell.center = center;
//                } completion:^(BOOL finished) {
                    [self fillAttributes];
                    topCell.alpha = 0;
                    [self.delegate layout:self didRemoveItemAtIndexpath:indexPath];
//                }];
            }
        } break;
        default:
            break;
    }
    [self invalidateLayout];
}

@end
