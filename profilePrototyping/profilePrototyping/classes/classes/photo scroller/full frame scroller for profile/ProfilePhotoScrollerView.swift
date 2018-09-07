//
//  ProfilePhotoScrollerView.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/7/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

/// конкретный скроллер конкретных вещей - фотографий юзера
class ProfilePhotoScrollerView: CollectionBasedScrollerView {
    override func layoutForCollection() -> UICollectionViewLayout {
        return PhotoScrollerViewLayout()
    }
    
    override func datasourceForCollection() -> CollectionSectionDatasource {
        return PhotosDatasource()
    }

    // MARK: animated bounds changing -
    
    override var contentMode: UIViewContentMode {
        didSet {
            if let layout = collectionView.collectionViewLayout as? PhotoScrollerViewLayout {
                layout.contentMode = contentMode
            }
        }
    }
}

// поддерживается один тип ячеек, из ксиба, cellId в ксибе для ячейки должен быть указан как "ProfileTopPhotoItem"
private class PhotosDatasource: CollectionSectionDatasource {
    override var supportedCellTypes: [CellType] {
        return [.ProfileTopPhotoItem]
    }
}

/// раскладка использует кастомный класс атрибутов для передачи в ячейку типа отображения фото - fit или fill
private class PhotoLayoutAttributes : UICollectionViewLayoutAttributes {
    var contentMode: UIViewContentMode = .scaleAspectFill
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let attrs = super.copy(with: zone) as! PhotoLayoutAttributes
        attrs.contentMode = contentMode
        return attrs
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? PhotoLayoutAttributes {
            if obj.contentMode != contentMode {
                return false
            } else {
                return super.isEqual(object)
            }
        } else {
            return false
        }
    }
}

private class PhotoScrollerViewLayout : UICollectionViewFlowLayout {
    var lastIndex: Int = NSNotFound
    
    override open class var layoutAttributesClass: Swift.AnyClass {
        get {
            return PhotoLayoutAttributes.self
        }
    }
    
    override var itemSize: CGSize {
        get {
            if let collection = collectionView {
                let w = collection.bounds.size.width - (collection.contentInset.left + collection.contentInset.right)
                let h = collection.bounds.size.height - (collection.contentInset.top + collection.contentInset.bottom)
                return CGSize(width: w, height: h)
            } else {
                return CGSize.zero
            }
        }
        set {
            super.itemSize = newValue
        }
    }
    
    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        if scrollDirection == .horizontal {
            lastIndex = Int(oldBounds.origin.x / oldBounds.size.width)
        } else {
            lastIndex = Int(oldBounds.origin.y / oldBounds.size.height)
        }
    }
    
    override func prepare() {
        super.prepare()
        
        if lastIndex != NSNotFound {
            var pt = collectionView!.contentOffset
            if scrollDirection == .horizontal {
                pt.x = CGFloat(lastIndex) * collectionView!.bounds.size.width
            } else {
                pt.y = CGFloat(lastIndex) * collectionView!.bounds.size.height
            }
            
            collectionView!.contentOffset = pt
            lastIndex = NSNotFound
        }
    }
    
    // MARK: contentMode -
    
    var contentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            invalidateLayout()
        }
    }
    
    // MARK: attributes -
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for obj in attributes {
                if let attrs = obj as? PhotoLayoutAttributes {
                    attrs.contentMode = contentMode
                }
            }
            return attributes
        } else {
            return nil
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attrs = super.layoutAttributesForItem(at: indexPath) as? PhotoLayoutAttributes {
            attrs.contentMode = contentMode
            return attrs
        }
        return nil
    }
}
