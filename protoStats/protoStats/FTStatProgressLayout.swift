//
//  FTStatProgressLayout.swift
//  protoStats
//
//  Created by Victor Zinets on 18.12.2022.
//

import UIKit

class FTStatProgressLayout: UICollectionViewLayout {
    
    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        guard
            let collection = collectionView,
            collection.numberOfSections == 1,
            collection.numberOfItems(inSection: 0) >= 3
        else { return }
        cachedAttributes.removeAll(keepingCapacity: true)
        
        var frame = collection.bounds
        
        for index in 0..<collection.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attrs.frame = frame
            frame = frame.insetBy(dx: strokeWidth + spacing, dy: strokeWidth + spacing)
            
            cachedAttributes.append(attrs)
        }
    }
    
    // MARK: - design
    var spacing: CGFloat = 2 {
        didSet {
            invalidateLayout()
        }
    }
    var strokeWidth: CGFloat = 18 {
        // он точно меняется под экран // TODO: Device.is4inch etc
        didSet {
            invalidateLayout()
        }
    }
    
    
    // MARK: - overrides
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collection = collectionView else { return .zero }
        
        return collection.bounds.size
    }
    
}
