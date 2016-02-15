//
//  Layout.m
//  testCollectionModes
//
//  Created by Zinets Victor on 1/29/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "Layout.h"

//NSString * const SupplementaryKindCollectionHeaderBanner = @"header_banner";
//NSString * const SupplementaryKindCollectionHeaderFlirtcast = @"header_flirtcast";
//
//NSString * const SupplementaryKindCollectionFooter = @"SupplementaryKindCollectionFooter";
//
//NSString * const SupplementaryKindSectionHeader = @"SupplementaryKindSectionHeader";
//NSString * const SupplementaryKindBanner = @"SupplementaryKindBanner";
//
NSString * const ItemKindCell_ = @"ItemKindCell";

@interface Layout () {
    NSMutableArray * usedFrames;
    NSMutableDictionary *attributes;
    CGSize contentSize;
}
@property (nonatomic, assign) CGFloat spacing; // расстояние между соседними ячейками
@property (nonatomic, assign) CGFloat inset; // расстояние от края
@end

@implementation Layout

- (void)optimize {
    if (usedFrames.count < 2) {
        return;
    }
    
    BOOL anyProcees = YES;
    while (anyProcees) {
        BOOL proceededH = YES;
        BOOL proceededV = YES;
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[usedFrames sortedArrayWithOptions:(0) usingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
            NSComparisonResult res = NSOrderedSame;
            CGRect f1 = [obj1 CGRectValue];
            CGRect f2 = [obj2 CGRectValue];
            if (f1.origin.y < f2.origin.y) {
                res = NSOrderedAscending;
            } else if (f1.origin.y > f2.origin.y) {
                res = NSOrderedDescending;
            }
            return res;
        }]];
        anyProcees = NO;
        while (proceededH) {
            // horizontal
            proceededH = NO;
            
            for (int x = 0; x < arr.count - 1; x++) {
                CGRect f1 = [arr[x] CGRectValue];
                CGRect f2 = [arr[x + 1] CGRectValue];
                if (f1.origin.y == f2.origin.y &&
                    f1.size.height == f2.size.height &&
                    f2.origin.x == f1.origin.x + f1.size.width + self.spacing) {
                    
                    CGRect newFrame = CGRectUnion(f1, f2);
                    arr[x] = [NSValue valueWithCGRect:newFrame];
                    [arr removeObjectAtIndex:x + 1];
                    
                    proceededH = YES;
                    anyProcees = YES;
                    break;
                }
            }
        }
        
        arr = [NSMutableArray arrayWithArray:[arr sortedArrayWithOptions:(0) usingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
            NSComparisonResult res = NSOrderedSame;
            CGRect f1 = [obj1 CGRectValue];
            CGRect f2 = [obj2 CGRectValue];
            if (f1.origin.x < f2.origin.x) {
                res = NSOrderedAscending;
            } else if (f1.origin.x > f2.origin.x) {
                res = NSOrderedDescending;
            }
            return res;
        }]];
        
        while (proceededV) {
            // vertical
            proceededV = NO;
            for (int x = 0; x < arr.count - 1; x++) {
                CGRect f1 = [arr[x] CGRectValue];
                CGRect f2 = [arr[x + 1] CGRectValue];
                if (f1.origin.x == f2.origin.x &&
                    f1.size.width == f2.size.width &&
                    f2.origin.y == f1.origin.y + f1.size.height + self.spacing) {
                    
                    CGRect newFrame = CGRectUnion(f1, f2);
                    arr[x] = [NSValue valueWithCGRect:newFrame];
                    [arr removeObjectAtIndex:x + 1];
                    
                    proceededV = YES;
                    anyProcees = YES;
                    break;
                }
            }
        }
        usedFrames = arr;
    }
}

- (CGRect)findRectForSize:(CGSize)newSize inRect:(CGRect)bounds {
    CGRect res = (CGRect){{self.inset, self.inset}, newSize};
    if (usedFrames.count > 0) {
        // в usedFrames уже соптимизированные блоки, но их надо отсортировать "по горизонтали"
        usedFrames = [NSMutableArray arrayWithArray:[usedFrames sortedArrayWithOptions:(0) usingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
            NSComparisonResult res = NSOrderedSame;
            CGRect f1 = [obj1 CGRectValue];
            CGRect f2 = [obj2 CGRectValue];
            if (f1.origin.y < f2.origin.y) {
                res = NSOrderedAscending;
            } else if (f1.origin.y > f2.origin.y) {
                res = NSOrderedDescending;
            }
            return res;
        }]];
        
        BOOL found = NO;
        CGFloat minHeight = CGFLOAT_MAX; // ну точнее это не высота, а миним. отступ блока от верха в текущем ряду
        while (!found) {
            BOOL intersected = NO;
            CGRect nextFrame;
            for (NSValue *obj in usedFrames) {
                nextFrame = [obj CGRectValue];
                if (CGRectIntersectsRect(nextFrame, res)) {
                    intersected = YES;
                    break;
                }
            }
            
            minHeight = MIN(minHeight, nextFrame.origin.y + nextFrame.size.height + self.spacing);
            
            if (intersected) {
                res.origin.x += nextFrame.size.width + self.spacing;
                if (res.origin.x + res.size.width > bounds.size.width) {
                    res.origin.y = minHeight;
                    res.origin.x = self.inset; // inset
                    
                    minHeight = nextFrame.origin.y + nextFrame.size.height + self.spacing;
                }
            } else {
                if (res.origin.x + res.size.width <= bounds.size.width) {
                    // этот фрейм нам подходит
                    found = YES;
                    break;
                }
            }
        }
    }
    [usedFrames addObject:[NSValue valueWithCGRect:res]];
    
    return res;
}

- (id)makeKeyForKind:(NSString *)kind section:(NSInteger)section row:(NSInteger)row {
    return [NSString stringWithFormat:@"%@_%@_%@", kind, @(section), @(row)];
}

- (CGSize)collectionViewContentSize {
    return contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    id key = [self makeKeyForKind:ItemKindCell_ section:indexPath.section row:indexPath.row];
    return attributes[key];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    id key = [self makeKeyForKind:kind section:indexPath.section row:indexPath.row];
    return attributes[key];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray * attrs = [NSMutableArray new];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, UICollectionViewLayoutAttributes * attr, BOOL *stop) {
        
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attrs addObject:attr];
        }
        
    }];
    return attrs;
}

- (NSIndexPath *)nearestToCenter:(UICollectionView *)cv {
    NSIndexPath *res = nil;
    CGPoint center = (CGPoint){cv.bounds.origin.x + cv.bounds.size.width / 2, cv.bounds.origin.y + cv.bounds.size.height / 2};
    CGFloat minDist = CGFLOAT_MAX;
    for (NSIndexPath *index in [cv indexPathsForVisibleItems]) {
        UICollectionViewLayoutAttributes *attr = [cv layoutAttributesForItemAtIndexPath:index];
        CGFloat x = center.x - attr.center.x;
        CGFloat y = center.y - attr.center.y;
        CGFloat dist = sqrt(x * x + y * y);
        if (dist < minDist) {
            res = index;
            minDist = dist;
        }
    };
    
    return res;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    UICollectionView <UICollectionViewDelegateFlowLayout> * cv = (id)self.collectionView;
    id <UICollectionViewDelegateFlowLayout> delegate = cv.delegate;
    
    NSInteger sectionsCount = 0;
    if (!usedFrames) {
        usedFrames = [NSMutableArray arrayWithCapacity:500];
    }
    [usedFrames removeAllObjects];
    
    contentSize = (CGSize){cv.bounds.size.width, 0};
    CGRect contentRect = (CGRect){CGPointZero, contentSize};
    
    if (!attributes) {
        attributes = [NSMutableDictionary dictionary];
    }
    [attributes removeAllObjects];
    
    sectionsCount = [cv numberOfSections];
    if (sectionsCount == 0) {
        return;
    }
    
    self.spacing = 8;
    //[self.dataSource minimumCellSpacingForLayout:self];
    self.inset = 11;
    //[self.dataSource sideCellInsetForLayout:self];
    
    // секции
    for (int section = 0; section < sectionsCount; section++) {
        
        NSInteger nums = [cv numberOfItemsInSection:section];
        CGFloat startPos = contentRect.size.height + self.inset;
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        id key = nil;
        // хедер секции
        CGSize sz = [delegate collectionView:cv layout:self referenceSizeForHeaderInSection:section];
        if (!CGSizeEqualToSize(sz, CGSizeZero)) {
//            key = [self makeKeyForKind:SupplementaryKindSectionHeader section:section row:0];
//            UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:SupplementaryKindSectionHeader withIndexPath:indexPath];
//            CGRect frm;
//
//            frm = (CGRect){(CGPoint){self.inset, startPos}, sz};
//            startPos += sz.height;
//            if (!CGRectIsEmpty(frm)) {
//                startPos += self.spacing;
//            }
//            
//            attr.frame = frm;
//            [attributes setObject:attr forKey:key];
//            [usedFrames addObject:[NSValue valueWithCGRect:frm]];
//            contentRect = CGRectUnion(contentRect, frm);
        }
        // ячейки
        for (int x = 0; x < nums; x++) {
            indexPath = [NSIndexPath indexPathForItem:x inSection:section];
            CGPoint pt = (CGPoint){self.inset, startPos};
            CGSize sz = [delegate collectionView:cv layout:self sizeForItemAtIndexPath:indexPath];
            //[self.dataSource layout:self cellSizeForIndexpath:indexPath];
            CGRect frame = (CGRect){pt, };
            
            frame = [self findRectForSize:sz inRect:contentRect];
            contentRect = CGRectUnion(contentRect, frame);
            
            UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attr.frame = frame;
            key = [self makeKeyForKind:ItemKindCell_ section:section row:x];
            [attributes setObject:attr forKey:key];
        } // cells in section
    } // sections
    if (contentRect.size.height > 0) contentRect.size.height += self.inset;
    contentSize = contentRect.size;
}

@end
