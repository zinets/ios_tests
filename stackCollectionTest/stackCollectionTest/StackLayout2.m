//
//  PHLookingForInfo+dd.m
//  stackCollectionTest
//
//  Created by Zinets Victor on 2/16/16.
//  Copyright © 2016 Zinets Victor. All rights reserved.
//

#import "StackLayout.h"
#import "StackCellAttributes.h"
#import "UIView+Geometry.h"
#import "Utils.h"

typedef NS_ENUM(NSUInteger, CellScrollingDirection) {
    CellScrollingDirectionNone,
    /// возвращаем назад смахнутую карточку
    CellScrollingDirectionRestoring,
    /// убираем с экрана карточку
    CellScrollingDirectionRemoving,
};

@interface StackLayout2 ()
@property (nonatomic, assign) CellScrollingDirection scrollDirection;
@end

@implementation StackLayout2 {
    NSMutableDictionary <NSIndexPath *, StackCellAttributes *> *attributes;
    
    UIPanGestureRecognizer *panRecognizer;
    CGPoint startPt, startCenter;
    UIView *fakeCell;
}

-(CGSize)collectionViewContentSize {
    CGSize sz = self.collectionView.bounds.size;
    sz.width -= self.collectionView.contentInset.left + self.collectionView.contentInset.right;
    sz.height -= self.collectionView.contentInset.top + self.collectionView.contentInset.bottom;
    return sz;
}

- (NSInteger)numberOfItems {
 #warning наверное уже не важно - датасорс следит
    return MIN(4, [self.collectionView numberOfItemsInSection:0]);
}

-(void)prepareLayout {
    [super prepareLayout];
    if (!attributes) {
        attributes = [NSMutableDictionary dictionary];
    }
    
    if (!panRecognizer) {
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanRecognized:)];
        [self.collectionView addGestureRecognizer:panRecognizer];
    }
    
    if (self.scrollDirection == CellScrollingDirectionRestoring) {
        [self createLayoutForRestoring];
    } else {
        [self createGeneralLayout];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray <UICollectionViewLayoutAttributes *> *res = [NSMutableArray array];
    for (int x = 0; x < [self numberOfItems]; x++) {
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

- (CGRect)normalFrame {
    static CGFloat const height = 415.0;
    return (CGRect){{15, 30}, {290, height}};
}

- (void)createGeneralLayout {
    NSInteger numberOfItems = [self numberOfItems];
    for (int x = 0; x < numberOfItems; x++) {
        NSIndexPath *idx = [NSIndexPath indexPathForItem:x inSection:0];
        StackCellAttributes *attr = attributes[idx];
        if (!attr) {
            attr = [StackCellAttributes layoutAttributesForCellWithIndexPath:idx];
            [attributes setObject:attr forKey:idx];
        }
        attr.zIndex = 100 - x;
        attr.frame = [self normalFrame];
        if (numberOfItems > 1) {
            attr.depth = (CGFloat) x / (numberOfItems - 1);
        }
    }
}

- (void)createLayoutForRestoring {
    NSInteger numberOfItems = [self numberOfItems];
    for (int x = 0; x < numberOfItems; x++) {
        NSIndexPath *idx = [NSIndexPath indexPathForItem:x inSection:0];
        StackCellAttributes *attr = attributes[idx];
        if (!attr) {
            attr = [StackCellAttributes layoutAttributesForCellWithIndexPath:idx];
            [attributes setObject:attr forKey:idx];
        }
        attr.zIndex = 100 - x;
        if (x == 0) {
            CGRect frm = [self normalFrame];
            frm.origin.x = self.collectionView.bounds.size.width - 1;
            attr.frame = frm;
            attr.depth = 0;
        } else {
            attr.frame = [self normalFrame];
            if (numberOfItems > 1) {
                attr.depth = (CGFloat) (x - 1) / (numberOfItems - 1);
            }
        }
    }
}

#pragma mark - gestures

- (void)onPanRecognized:(UIPanGestureRecognizer *)sender {
    CGPoint pt = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            // запоминаем точку первого тапа - она нужна для определения сдвига относительно начала процесса
            startPt = pt;
            self.scrollDirection = CellScrollingDirectionNone;
            
        } break;
        case UIGestureRecognizerStateChanged: {
            CGFloat delta = pt.x - startPt.x;
            // мы можем пальцем возюкать туды-сюды, но определив раз направление больше не меняем тип!
            if (self.scrollDirection == CellScrollingDirectionNone) {
                if (delta < 0 && [self.delegate hasRemovedItems:self]) {
                    self.scrollDirection = CellScrollingDirectionRestoring;
                    [self.delegate layout:self willRestoreItemAtIndexpath:indexPath];
                } else {
                    self.scrollDirection = CellScrollingDirectionRemoving;

                } // думаю нет смысла проверять вариант, когда смещение == 0
                
                // теперь если сделать релоад, то а) сделается пересчет раскладки - нам нужно чтобы одна ячейка уже была "за экраном" б) ячейки загрузятся и визуально ничего не меняется, но на самом деле на верху стопки будет элемент 1, а в элемент 0 (за экраном) загрузится "предыдущий" элемент
                [self.collectionView reloadData];
            }

            // теперь теоретически после релоада вот самая верхняя ячейка; это не обязательно верхняя ячейка в стопке, это может быть и возвращаемая на экран ячейка
            UICollectionViewCell *topCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            if (!fakeCell) {
                // это "картинка" ячейки, которую будем двигать - так проще, чем возюкаться с ячейкой
                startCenter = topCell.center;

                fakeCell = [topCell snapshotViewAfterScreenUpdates:YES];
                // тут надо предусмотреть, что ячейка должна себя скруглять при необходимости так, чтобы все эти скругления получились на скриншоте без лишних телодвижений; т.е. если сделать скругление к примеру слою ячейки - то скриншот будет прямоугольный с черными уголками - поэтому надо или класть-ложить вью для фона, или делать скругление к примеру contentView
                [self.collectionView addSubview:fakeCell];
                fakeCell.frame = topCell.frame;
                fakeCell.alpha = 1;
            }
            topCell.alpha = 0;
            // ячейку, чей светлый образ возюкаем по экрану, прячем
            
            NSInteger numberOfCells = [self numberOfItems];
            CGPoint center = startCenter;
            // delta - это сдвиг относительно старта процесса
            
            // обработка движений раздельная для "убрать/восстановить" - может быть (?) потом все же унифицируется, но пока что все в другую сторону
            switch (self.scrollDirection) {
                case CellScrollingDirectionRemoving: {
                    center.x += delta;
                    CGFloat depth = 1; // расчет - на сколько меняется "глубина" ячейки при сдвиге топовой ячейки
                    if (numberOfCells > 1) {
                        CGFloat maxDepth = 1.0 / (numberOfCells - 1);
                        depth = MAX(0, MIN(maxDepth, delta / (self.collectionView.bounds.size.width / 2) / (numberOfCells - 1)));
                    }
                    NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                    [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj isEqual:indexPath]) {
                            StackCellAttributes *attr = [attributes[obj] copy];
                            attr.depth -= depth; // copy чтобы не накапливалось изменение лавинообразно - вычисленное значение - это абс. значение от старта процесса; кроме того я не хочу менять кешированные атрибуты
                            [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                        }
                    }];
                    // показали образ ячейки в новой точке
                    fakeCell.center = center;
                } break;
                case CellScrollingDirectionRestoring: {
                    center.x += delta;
                    CGFloat maxDepth = 1.0 / (numberOfCells - 1);
                    CGFloat depth = MAX(0, MIN(maxDepth, -delta / (self.collectionView.bounds.size.width / 2) / (numberOfCells - 1)));
                    // depth - глубина для текущего сдвига; все ячейки опускаем на эту глубину - кроме "топовой"
                    NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                    [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj isEqual:indexPath]) {
                            StackCellAttributes *attr = [attributes[obj] copy];
                            attr.depth += depth;
                            [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                        }
                    }];
                    fakeCell.center = center;
                } break;
                default:
                    break;
            }
        } break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            UICollectionViewCell *topCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            CGPoint v = [sender velocityInView:sender.view];
            CGFloat timeToPredict = 0.15;
            CGFloat delta = pt.x - startPt.x;
            __block CGPoint center = startCenter;
            center.x += delta + timeToPredict * v.x;
            // предсказали место ячейки после отпускания:
            switch (self.scrollDirection) {
                case CellScrollingDirectionRemoving: {
                    if (center.x > self.collectionView.bounds.size.width) { // смахивание вправо срабатывает если не просто "за фрейм", а именно вправо за фрейм
                        center.x += self.collectionView.bounds.size.width;
                        [UIView animateWithDuration:.25 animations:^{
                            // убираем фейковую ячейку вправо за экран, с фейдом в 0, потом обнулить фейковую ячейку
                            fakeCell.center = center;
                            fakeCell.alpha = 0;
                            
                            [self.delegate layout:self didRemoveItemAtIndexpath:indexPath];
                            // метод делегата сдвинет индекс в датасорсе - для стока это не надо, но у нас же должно быть "скольжение" по списку юзеров
                            
                            [self createLayoutForRestoring];
                            NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                            [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (![obj isEqual:indexPath]) {
                                    StackCellAttributes *attr = attributes[obj];
                                    [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                                }
                            }];
                        } completion:^(BOOL finished) {
                            [self.collectionView reloadData];
                            [fakeCell removeFromSuperview];
                            fakeCell = nil;
                        }];
                    } else {
                        // если не дотянули до выбрасывания - надо "откатить" все назад, к точке старта действия
                        center = startCenter;
                        [UIView animateWithDuration:0.25 animations:^{
                            fakeCell.center = center;
                            NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                            [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                // восстанавливаем атрибуты ячеек - кроме 1-й, которую мы спрятали и вместо нее возюкаем картинку; если восстановить и ее атрибуты - появится дубль в точке, куда все возарвщвется
                                if (![obj isEqual:indexPath]) {
                                    StackCellAttributes *attr = attributes[obj];
                                    [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                                }
                            }];
                        } completion:^(BOOL finished) {
                            topCell.alpha = 1;
                            fakeCell.alpha = 0;
                            [fakeCell removeFromSuperview];
                            fakeCell = nil;
                        }];
                    }
                } break;
                case CellScrollingDirectionRestoring: {
                    if (center.x < self.collectionView.bounds.size.width) { // возрващаем
                        UICollectionViewLayoutAttributes *attr = attributes[[NSIndexPath indexPathForItem:1 inSection:0]];
                        center = attr.center;
                        [UIView animateWithDuration:0.25 animations:^{
                            fakeCell.center = center;
                            self.scrollDirection = CellScrollingDirectionNone;
                            [self createGeneralLayout];
                            NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                            [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (![obj isEqual:indexPath]) {
                                    StackCellAttributes *attr = attributes[obj];
                                    [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                                }
                            }];
                        } completion:^(BOOL finished) {
                            [self.collectionView reloadData];
                            topCell.center = startCenter;
                            topCell.alpha = 1;
                            [fakeCell removeFromSuperview];
                            fakeCell = nil;
                        }];
                    } else {
                        center = startCenter;
                        [UIView animateWithDuration:0.25 animations:^{
                            fakeCell.center = center;
                            [self.delegate layout:self didRemoveItemAtIndexpath:indexPath];
                            self.scrollDirection = CellScrollingDirectionNone;
                            
                            NSArray <NSIndexPath *> *cells = [self.collectionView indexPathsForVisibleItems];
                            [cells enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                if (![obj isEqual:indexPath]) {
                                    StackCellAttributes *attr = attributes[obj];
                                    [[self.collectionView cellForItemAtIndexPath:obj] applyLayoutAttributes:attr];
                                }
                            }];
                        } completion:^(BOOL finished) {
                            topCell.alpha = 1;
                            fakeCell.alpha = 0;
                            [fakeCell removeFromSuperview];
                            fakeCell = nil;
                            
                            [self.collectionView reloadData];
                        }];
                    }
                } break;
                default:
                    break;
            }
        } break;
        default:
            break;
    }
}

@end
