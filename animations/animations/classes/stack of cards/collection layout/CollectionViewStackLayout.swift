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
        attrs.zIndex = -indexPath.item // порядок карточек
        attrs.frame = self.cellSizeFor(indexPath.item) // перспективно уходящие карточки
        attrs.isHidden = !(indexPath.item < numberOfVisibleCells) // прячем "лишние" карточки
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
        return attributes[indexPath]
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return Array(attributes.values)
    }
    
    private var itemsToDelete: [IndexPath] = []
    private var itemsToInsert: [IndexPath] = []
    
    // TODO: тут как-то для "тонкой" настройки надо добавить механику получения начальных/удаляемых трансформов
    
    public override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        itemsToDelete = updateItems.filter{ $0.updateAction == .delete }.compactMap{ $0.indexPathBeforeUpdate }
        itemsToInsert = updateItems.filter{ $0.updateAction == .insert }.compactMap{ $0.indexPathAfterUpdate }        
    }
    
    public override func finalizeCollectionViewUpdates() {
        itemsToDelete.removeAll()
        itemsToInsert.removeAll()
    }
    
    public override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard itemsToInsert.contains(itemIndexPath) else { return nil }
        
//        let attrs = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)?.copy() as! UICollectionViewLayoutAttributes
        let attrs = self.attributesForIndex(itemIndexPath)
        attrs.alpha = 0
        
        return attrs
    }
    
    public override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard itemsToDelete.contains(itemIndexPath) else { return nil }
        
//        let attrs = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)?.copy() as! UICollectionViewLayoutAttributes
        let attrs = self.attributesForIndex(itemIndexPath)
        
        let rotationStrength: CGFloat = self.removingDirection == .left ? -0.5 : 0.5
        let rotationAngle = CGFloat.pi / 3 * rotationStrength
        
        var transform = CATransform3DIdentity
        
        transform = CATransform3DTranslate(transform, self.removingDirection == .left ? -300 : 300, 0, 0)
        transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
        
        attrs.transform3D = transform
        attrs.alpha = 0
        attrs.zIndex += 1
        return attrs
    }
}

