//
//  ProfilePhotoScrollerLayout.swift
//  profilePrototyping
//
//  Created by Victor Zinets on 9/14/18.
//  Copyright © 2018 Victor Zinets. All rights reserved.
//

import UIKit

class ProfilePhotoScrollerLayout : UICollectionViewFlowLayout {
    
    var lastIndex: Int = NSNotFound
    
    override open class var layoutAttributesClass: Swift.AnyClass {
        get {
            return ProfilePhotoScrollerLayoutAttributes.self
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
                pt.x = CGFloat(lastIndex) * (collectionView!.bounds.size.width + minimumInteritemSpacing)
            } else {
                pt.y = CGFloat(lastIndex) * (collectionView!.bounds.size.height + minimumInteritemSpacing)
            }
            
            collectionView!.contentOffset = pt
            lastIndex = NSNotFound
        }
    }
    
    // MARK: custom properties -
    
    var contentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            invalidateLayout()
        }
    }
    
    var zoomEnabled = false {
        didSet {
            invalidateLayout()
        }
    }
       
    // MARK: attributes -
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for obj in attributes {
                if let attrs = obj as? ProfilePhotoScrollerLayoutAttributes {
                    attrs.contentMode = contentMode
                    attrs.zoomEnabled = zoomEnabled
                }
            }
            return attributes
        } else {
            return nil
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attrs = super.layoutAttributesForItem(at: indexPath) as? ProfilePhotoScrollerLayoutAttributes {
            attrs.contentMode = contentMode
            attrs.zoomEnabled = zoomEnabled
            return attrs
        }
        return nil
    }
}
