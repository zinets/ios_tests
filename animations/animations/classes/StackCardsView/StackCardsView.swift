//
//  StackCardsView.swift
//  animations
//
//  Created by Viktor Zinets on 24.02.2020.
//  Copyright © 2020 Viktor Zinets. All rights reserved.
//

import UIKit
import DiffAble

class StackCardsView: UICollectionView {

    private var layout = StackCardsLayout()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.collectionViewLayout = self.layout
    }
    
    var removingDirection: SwipeDirection {
        set {
            layout.removingDirection = newValue
        }
        get {
            return layout.removingDirection
        }
    }
        
}



internal class StackCardsLayout: UICollectionViewLayout {

//    enum SwipeDirection { // с одной стороны дублирование (в Swipeable есть по смыслу тот же энум)
//        case left, right  // с другой универсальность
//    }

    var numberOfVisibleCells: Int = 3 {
        didSet {
            invalidateLayout()
        }
    }
    var removingDirection = SwipeDirection.accept
    
    // MARK: overrides -
    public override var collectionViewContentSize: CGSize {
        return self.collectionView?.bounds.size ?? .zero
    }
    
    private var attributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    override func prepare() {
        
        guard let collection = self.collectionView,
        collection.numberOfSections > 0 else { return }
        
        attributes.removeAll()
        
        let nums = collection.numberOfItems(inSection: 0)
        (0..<nums).forEach { (index) in
            let indexPath = IndexPath(item: index, section: 0)
            attributes[indexPath] = self.attributesForIndex(indexPath)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return Array(attributes.values)
    }
    
    // MARK: appearance -
    private func cellSizeFor(_ index: Int) -> CGRect {
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
    
    // MARK: insert/detete -
    private var itemsToDelete: [IndexPath] = []
    private var itemsToInsert: [IndexPath] = []
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        itemsToDelete = updateItems.filter{ $0.updateAction == .delete }.compactMap{ $0.indexPathBeforeUpdate }
        itemsToInsert = updateItems.filter{ $0.updateAction == .insert }.compactMap{ $0.indexPathAfterUpdate }
    }
    
    public override func finalizeCollectionViewUpdates() {
        itemsToDelete.removeAll()
        itemsToInsert.removeAll()
    }
    
    // TODO: тут как-то для "тонкой" настройки надо добавить механику получения начальных/удаляемых трансформов
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard itemsToInsert.contains(itemIndexPath) else { return nil }
        let attrs = self.attributesForIndex(itemIndexPath)
        attrs.alpha = 0
        
        return attrs
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        guard itemsToDelete.contains(itemIndexPath) else { return nil }
        let attrs = self.attributesForIndex(itemIndexPath)
        
        let rotationStrength: CGFloat = self.removingDirection == .decline ? -0.5 : 0.5
        let rotationAngle = CGFloat.pi / 3 * rotationStrength
        
        var transform = CATransform3DIdentity
        
        transform = CATransform3DTranslate(transform, self.removingDirection == .decline ? -300 : 300, 0, 0)
        transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
        
        attrs.transform3D = transform
        attrs.alpha = 0
        attrs.zIndex += 1
        return attrs
    }
}


