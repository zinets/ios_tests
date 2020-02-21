//
//  CollectionViewStackLayout.swift
//  animations
//
//  Created by Viktor Zinets on 21.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit

public class CollectionViewStackLayout: UICollectionViewLayout {
    
    var numberOfVisibleCells: Int = 3
    enum SwipeDirection { // с одной стороны дублирование (в Swipeable есть по смыслу тот же энум)
        case left, right  // с другой универсальность
    }
    var removingDirection = SwipeDirection.right
    
    // нельзя просто так взять и сказать, что размер контента == размеру коллекции - тогда коллекция не увидит смысла создавать больше 2-х ячеек (одна на экране, одна может быть появится)
    // хотя это замечание касается только случая, когда перегружаются методы layoutAttributesFor... flowLayout-а - т.к. базовый класс определяет по контент-сайзу кол-во элементов, которые "влезают" для показа
    // если по старинке формировать аттрибуты в prepare - то очевидно сделаем столько, сколько нужно
    public override var collectionViewContentSize: CGSize {
        return self.collectionView?.bounds.size ?? .zero
    }
    
    // to override (например чтобы пустить стопку в другую сторону или просто изменить параметры карточек стопки)
    public func cellSizeFor(_ index: Int) -> CGRect {
        guard let collection = self.collectionView else {
            return .zero
        }

        let sideOffset: CGFloat = 16
        let bottomMargin: CGFloat = 16
        let topOffset: CGFloat = 40
        // рассчет для дизайна, когда нижние ячейки смещаются вниз
        /**
         +------------+
         |            |
         |            |
         |            |
         +------------+
          +----------+
           +--------+
         */
        let x = sideOffset * CGFloat(index)
        let w = collection.bounds.width - 2 * x
        let y = topOffset * CGFloat(index)
        let h = collection.bounds.height - y - bottomMargin * CGFloat(numberOfVisibleCells - index - 1)
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    private func attributesForIndex(_ indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attrs.zIndex = -indexPath.item
        attrs.frame = self.cellSizeFor(indexPath.item)
        attrs.isHidden = !(indexPath.item < numberOfVisibleCells)
        return attrs
    }
    
    private var attributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    public override func prepare() {
        
        guard let collection = self.collectionView,
        collection.numberOfSections > 0 else { return }
        
        attributes.removeAll()
        
        let nums = collection.numberOfItems(inSection: 0)
        (0..<nums).forEach { (index) in
            let indexPath = IndexPath(item: index, section: 0)
            attributes[indexPath] = self.attributesForIndex(indexPath)
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let collection = self.collectionView,
//            collection.numberOfSections > 0 else { return nil }
        // кроме того надо ограничить количеством видимых ячеек
//        return self.attributesForIndex(indexPath)
        return attributes[indexPath]
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

//        guard let collection = self.collectionView,
//            collection.numberOfSections > 0 else { return nil }
//
//        let nums = min(numberOfVisibleCells, collection.numberOfItems(inSection: 0))
//        return (0..<nums).map { (index) -> UICollectionViewLayoutAttributes in
//            self.attributesForIndex(IndexPath(item: index, section: 0))
//        }
        return Array(attributes.values)
    }
    
    
    private var itemsToDelete: [IndexPath] = []
    private var itemsToInsert: [IndexPath] = []
    
    public override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        updateItems.forEach { (updatedItem) in
            switch updatedItem.updateAction {
            case .delete:
                if let index = updatedItem.indexPathBeforeUpdate {
                    itemsToDelete.append(index)
                }
            case .insert:
                if let index = updatedItem.indexPathAfterUpdate {
                    itemsToInsert.append(index)
                }
            default:
                break
            }
        }
    }
    
    public override func finalizeCollectionViewUpdates() {
        itemsToDelete.removeAll()
        itemsToInsert.removeAll()
    }
    
    public override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard itemsToInsert.contains(itemIndexPath) else { return nil }
        
        let attrs = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)?.copy() as! UICollectionViewLayoutAttributes
        
        attrs.alpha = 0
        
        return attrs
    }
    
    public override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard itemsToDelete.contains(itemIndexPath) else { return nil }
        
        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)?.copy() as! UICollectionViewLayoutAttributes
        
        let rotationStrength: CGFloat = self.removingDirection == .left ? -0.5 : 0.5
        let rotationAngle = CGFloat.pi / 3 * rotationStrength
        
        var transform = CATransform3DIdentity
        
        transform = CATransform3DTranslate(transform, self.removingDirection == .left ? -300 : 300, 0, 0)
        transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
        
        attrs.transform3D = transform
        attrs.alpha = 0
        return attrs
    }
}

